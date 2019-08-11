{ stdenv, fetchFromGitHub, lib, makeWrapper, which
, bash, coreutils, gnugrep, gnused, gawk, curl, findutils
, utillinux, openssl, openssh, cacert }:

stdenv.mkDerivation rec {
  pname = "ec2-instance-connect";
  version = "1.0-9";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-ec2-instance-connect-config";
    rev = version;
    sha256 = "1gw4shjpsp7pzmc76mynr6vfhay88gdn9dsmqg258225lwjwigrh";
  };

  installPhase = ''
    mkdir $out
    cp -r src/bin $out
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    bash coreutils gnugrep gnused gawk curl findutils
    utillinux openssl openssh
  ];

  fixupPhase = ''
    # Most tools are called as /bin/$tool or /usr/bin/tool. This
    # script replaces all such references with their versions from
    # buildInputs.

    $SHELL ${./fixup-bin-paths.sh} \
      $out/bin \
      ${which}/bin/which \
      ${lib.escapeShellArg (lib.makeBinPath buildInputs)}

    substituteInPlace $out/bin/eic_curl_authorized_keys \
      --replace 'ca_path=/etc/ssl/certs' 'ca_path=/etc/ssl/certs/ca-bundle.crt'

    # Some tools from coreutils (wc, rm, dirname) are referenced without
    # an absolute path.
    for script in $out/bin/*; do
      wrapProgram "$script" --prefix PATH : ${lib.makeBinPath [ coreutils ]}
    done
  '';

  meta = {
    homepage = https://github.com/aws/aws-ec2-instance-connect-config;
    description = "EC2 instance scripting to enable EC2 Instance Connect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thefloweringash ];
  };
}
