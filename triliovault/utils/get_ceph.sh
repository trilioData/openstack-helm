#!/bin/bash -x

set -e


NOVA_CEPH_KEYRING=$(kubectl -n rook-ceph get secrets/rook-ceph-client-nova --template={{.data.nova}} | base64 -d)
kubectl -n openstack get configmap/rook-ceph-config -o "jsonpath={.data['ceph\.conf']}" > ../templates/bin/_triliovault-ceph.conf.tpl

cd ../

tee > values_overrides/ceph.yaml  << EOF
ceph:
  enabled: true
  conf: ""
  rbd_user: nova
  keyring: $NOVA_CEPH_KEYRING
EOF

