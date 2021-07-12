# This combines together OCF definitions from other derivations.
# https://github.com/ClusterLabs/resource-agents/blob/master/doc/dev-guides/ra-dev-guide.asc
{ stdenv
, lib
, runCommand
, lndir
, resource-agents
, drbd-utilsForOCF
, pacemakerForOCF
} :

runCommand "ocf-resource-agents" {} ''
  mkdir -p $out/usr/lib/ocf
  ${lndir}/bin/lndir -silent "${resource-agents}/lib/ocf/" $out/usr/lib/ocf
  ${lndir}/bin/lndir -silent "${drbd-utilsForOCF}/usr/lib/ocf/" $out/usr/lib/ocf
  ${lndir}/bin/lndir -silent "${pacemakerForOCF}/usr/lib/ocf/" $out/usr/lib/ocf
''
