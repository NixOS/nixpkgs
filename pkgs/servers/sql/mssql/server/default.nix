{ stdenv
, fetchurl
, lib
, rpmextract
, makeWrapper
, bash
, python2
, numactl
, kerberos
, e2fsprogs
, sssd
, libuuid
, pam
, openldap
, systemd
, libunwind
, libredirect
}:

with lib;

let
  pname = "mssql-server";
  version = "15.0.4003.23-3";
  fetch-package = { pname, version, sha256 }:
    fetchurl {
      inherit sha256;
      url =
        "https://packages.microsoft.com/rhel/7/mssql-server-2019/${pname}-${version}.x86_64.rpm";
    };
  packages = {
    mssql-server = fetch-package {
      inherit pname version;
      sha256 = "2c617e905b553e32b37b48f2d3cbce9bc6274e1e2f56172ff9efd696d264bbbc";
    };
    mssql-server-fts = fetch-package {
      inherit version;
      pname = "${pname}-fts";
      sha256 = "1sd789sy30x92c8cj3lwb93w1fjx4w3vglh49sgdpr6dsm01l9yd";
    };
  };

  withPackages = mssql-pkgs:

    stdenv.mkDerivation rec {

      inherit pname version;
      dontUnpack = true;
      nativeBuildInputs = [
        makeWrapper
        rpmextract
      ];

      ldLibraryPath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc
        numactl
        kerberos
        e2fsprogs
        sssd
        libuuid
        pam
        openldap
        systemd.lib
        libunwind
      ];

      installPhase = ''
        runHook preInstall
        rpmextract ${builtins.concatStringsSep " " mssql-pkgs}
        mkdir -p $out/bin
        mv opt $out
        mv usr $out

        fix_bash()
        {
          for x in $@; do
            substituteInPlace "$x" \
              --replace '/bin/bash' "${bash}/bin/bash"
          done
        }

        fix_bash \
          $out/opt/mssql/bin/mssql-conf \
          $out/opt/mssql/lib/mssql-conf/{invokesqlservr,checkinstall}.sh

        fix_python()
        {
          for x in $@; do
            substituteInPlace "$x" \
              --replace '/usr/bin/python2' "${python2}/bin/python"
          done
        }

        fix_python $out/opt/mssql/lib/mssql-conf/{mssqlsettingsmanager,mssql-conf,mssqlconfhelper,mssqlsettings}.py

        fix_sqlserver()
        {
          for x in $@; do
            substituteInPlace "$x" \
              --replace '/opt/mssql/bin/sqlservr' "$out/opt/mssql/bin/sqlservr"
          done
        }

        fix_sqlserver \
          $out/opt/mssql/lib/mssql-conf/{set-collation,invokesqlservr}.sh \
          $out/usr/lib/systemd/system/mssql-server.service

        chmod +x $out/opt/mssql/bin/sqlservr

        fix_interpreter()
        {
          for x in $@; do
            patchelf \
              --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
              "$x"
          done
        }

        fix_interpreter $out/opt/mssql/bin/{paldumper,sqlservr}

        wrap()
        {
          for x in $@; do
            wrapProgram $out/opt/mssql/bin/$x \
              --suffix LD_LIBRARY_PATH : ${ldLibraryPath}
            ln -s $out/opt/mssql/bin/$x $out/bin/
          done
        }

        wrap paldumper sqlservr

        runHook postInstall
      '';

      dontStrip = true;

      meta = {
        maintainers = with stdenv.lib.maintainers; [ xavierzwirtz ];
        description = "A relational database management system developed by Microsoft";
        homepage = https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-overview;
        license = licenses.unfreeRedistributable;
      };
    };
in

withPackages [ packages.mssql-server ] // {
  inherit withPackages packages;
}
