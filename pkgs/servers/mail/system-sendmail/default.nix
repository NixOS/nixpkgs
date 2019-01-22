{ stdenv, writeText }:

let script = writeText "script" ''
  #!${stdenv.shell}

  if command -v sendmail > /dev/null 2>&1 && [ "$(command -v sendmail)" != "{{MYPATH}}" ]; then
    exec sendmail "$@"
  elif [ -x /run/wrappers/bin/sendmail ]; then
    exec /run/wrappers/bin/sendmail "$@"
  elif [ -x /run/current-system/sw/bin/sendmail ]; then
    exec /run/current-system/sw/bin/sendmail "$@"
  else
    echo "Unable to find system sendmail." >&2
    exit 1
  fi
''; in
stdenv.mkDerivation {
  name = "system-sendmail-1.0";

  src = script;

  phases = [ "buildPhase" ];
  buildPhase = ''
    mkdir -p $out/bin
    < $src sed "s#{{MYPATH}}#$out/bin/sendmail#" > $out/bin/sendmail
    chmod +x $out/bin/sendmail
  '';

  meta = with stdenv.lib; {
    description = ''
      A sendmail wrapper that calls the system sendmail. Do not install as system-wide sendmail!
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [ ekleog ];
  };
}
