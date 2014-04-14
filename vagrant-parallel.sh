#!/bin/sh
 
# concurrency is hard, let's have a beer
if [ "$1" = "clean" ]; then
  echo "clean the previous running logs..."
  rm *.txt
fi
 
MAX_PROCS=3
 
parallel_provision() {
    while read box; do
        echo "Provisioning '$box'. Output will be in: $box.out.txt" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant provision BOXNAME >BOXNAME.out.txt 2>&1 || echo "Error Occurred: BOXNAME"'
}
 
## -- main -- ##
 
# start boxes sequentially to avoid vbox explosions
vagrant up --no-provision
 
# but run provision tasks in parallel
#cat <<EOF | parallel_provision
#icehouse1
#icehouse2
#icehouse3
#icehouse4
#EOF
# but run provision tasks in parallel
cat <<EOF | parallel_provision
controller
network
compute
EOF
