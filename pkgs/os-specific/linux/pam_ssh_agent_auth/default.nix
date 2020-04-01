{ stdenv, fetchpatch, fetchurl, pam, openssl, perl }:

stdenv.mkDerivation rec {
  name = "pam_ssh_agent_auth-0.10.3";

  src = fetchurl {
    url = "mirror://sourceforge/pamsshagentauth/${name}.tar.bz2";
    sha256 = "0qx78x7nvqdscyp04hfijl4rgyf64xy03prr28hipvgasrcd6lrw";
  };

  patches =
    [ # Allow multiple colon-separated authorized keys files to be
      # specified in the file= option.
      ./multiple-key-files.patch
      (fetchpatch {
        name = "openssl-1.1.1-1.patch";
        url = "https://sources.debian.org/data/main/p/pam-ssh-agent-auth/0.10.3-3/debian/patches/openssl-1.1.1-1.patch";
        sha256 = "1ndp5j4xfhzshhnl345gb4mkldx6vjfa7284xgng6ikhzpc6y7pf";
      })
      (fetchpatch {
        name = "openssl-1.1.1-2.patch";
        url = "https://sources.debian.org/data/main/p/pam-ssh-agent-auth/0.10.3-3/debian/patches/openssl-1.1.1-2.patch";
        sha256 = "0ksrs4xr417by8klf7862n3dircvnw30an1akq4pnsd3ichscmww";
      })
    ];

  buildInputs = [ pam openssl perl ];

  # It's not clear to me why this is necessary, but without it, you see:
  #
  # checking OpenSSL header version... 1010104f (OpenSSL 1.1.1d  10 Sep 2019)
  # checking OpenSSL library version... 1010104f (OpenSSL 1.1.1d  10 Sep 2019)
  # checking whether OpenSSL's headers match the library... no
  # configure: WARNING: Your OpenSSL headers do not match your
  # library. Check config.log for details.
  #
  # ...despite the fact that clearly the values match
  configureFlags = [ "--without-openssl-header-check" ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://pamsshagentauth.sourceforge.net/;
    description = "PAM module for authentication through the SSH agent";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
