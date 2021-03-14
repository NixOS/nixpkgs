{ lib, stdenv, fetchFromGitHub, pkg-config
, libuuid
}:

stdenv.mkDerivation rec {
  pname = "nvme-cli";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    sha256 = "1d538kp841bjh8h8d9q7inqz56rdcwb3m78zfx8607ddykv7wcqb";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libuuid ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  # To omit the hostnqn and hostid files that are impure and should be unique
  # for each target host:
  installTargets = [ "install-spec" ];

  meta = with lib; {
    inherit (src.meta) homepage; # https://nvmexpress.org/
    description = "NVM-Express user space tooling for Linux";
    longDescription = ''
      NVM-Express is a fast, scalable host controller interface designed to
      address the needs for not only PCI Express based solid state drives, but
      also NVMe-oF(over fabrics).
      This nvme program is a user space utility to provide standards compliant
      tooling for NVM-Express drives. It was made specifically for Linux as it
      relies on the IOCTLs defined by the mainline kernel driver.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos tavyc ];
  };
}
