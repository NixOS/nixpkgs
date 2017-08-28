{ buildPythonPackage, qtbase, stdenv, fetchFromGitHub,
  trezor, libagent, lib, pinentry
}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "trezor_agent";
  version = "0.12.0";

  src = "${fetchFromGitHub {
    repo = "trezor-agent";
    owner = "romanz";
    rev = "7f9aa2b1477aaf411ae5dba382f0e7681d9925c9";
    sha256 = "1jsijl7ik8q71g1idg182yvqkcg1iggpg6wspj9r2c5hzq2n2qjz";
  }}/agents/trezor";

  propagatedBuildInputs = [ trezor libagent ];

  postFixup = ''
    # fix for qt pinentry in non-tty environments such as systemd services
    wrapProgram $out/bin/trezor-gpg-agent \
      --set QT_QPA_PLATFORM_PLUGIN_PATH "${qtbase.bin}/lib/qt-*/plugins/platforms/" \
      --prefix PATH : ${lib.makeBinPath [ pinentry ]}

    wrapProgram $out/bin/trezor-gpg \
      --prefix PATH : ${lib.makeBinPath [ pinentry ]}
  '';

  meta = with stdenv.lib; {
    description = "Using Trezor as hardware SSH agent";
    homepage = https://github.com/romanz/trezor-agent;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jb55 np ];
  };
}
