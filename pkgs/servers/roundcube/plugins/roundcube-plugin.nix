{ runCommand }:
{
  pname,
  version,
  src,
}:

runCommand "roundcube-plugin-${pname}-${version}" { } ''
  mkdir -p $out/plugins/
  cp -r ${src} $out/plugins/${pname}
''
