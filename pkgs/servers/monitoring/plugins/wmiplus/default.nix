{ lib, stdenv, fetchFromGitHub, makeWrapper, perlPackages, txt2man
, monitoring-plugins
, wmic-bin ? null }:

stdenv.mkDerivation rec {
  pname = "check-wmiplus";
  version = "1.65";

  # We fetch from github.com instead of the proper upstream as nix-build errors
  # out with 406 when trying to fetch the sources
  src = fetchFromGitHub {
    owner = "speartail";
    repo = "checkwmiplus";
    rev = "v${version}";
    sha256 = "1as0iyhy4flpm37mb7lvah7rnd6ax88appjm1icwhy7iq03wi8pl";
  };

  patches = [
    ./wmiplus_fix_manpage.patch
  ];

  propagatedBuildInputs = with perlPackages; [
    BHooksEndOfScope ClassDataInheritable ClassInspector ClassSingleton
    ConfigIniFiles DateTime DateTimeLocale DateTimeTimeZone DevelStackTrace
    EvalClosure ExceptionClass FileShareDir ModuleImplementation ModuleRuntime
    MROCompat namespaceautoclean namespaceclean NumberFormat PackageStash
    ParamsValidate ParamsValidationCompiler RoleTiny Specio
    SubExporterProgressive SubIdentify TryTiny
  ];

  nativeBuildInputs = [ makeWrapper txt2man ];

  dontConfigure = true;
  dontBuild = true;
  doCheck = false; # no checks

  postPatch = ''
    substituteInPlace check_wmi_plus.pl \
      --replace /usr/bin/wmic                      ${wmic-bin}/bin/wmic \
      --replace /etc/check_wmi_plus                $out/etc/check_wmi_plus \
      --replace /opt/nagios/bin/plugins            $out/etc/check_wmi_plus \
      --replace /usr/lib/nagios/plugins            ${monitoring-plugins}/libexec \
      --replace '$base_dir/check_wmi_plus_help.pl' "$out/bin/check_wmi_plus_help.pl"

    for f in *.pl ; do
      substituteInPlace $f --replace /usr/bin/perl ${perlPackages.perl}/bin/perl
    done
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin *.pl
    install -Dm644 -t $out/share/doc/${pname} *.txt
    cp -r etc $out/

    runHook postInstall
  '';

  # 1. we need to wait until the main binary has been fixed up with proper perl paths before we can run it to generate the man page
  # 2. txt2man returns exit code 3 even if it works, so we add the || true bit
  postFixup = ''
    wrapProgram $out/bin/check_wmi_plus.pl \
      --set PERL5LIB "${perlPackages.makePerlPath propagatedBuildInputs}"

    mkdir -p $out/share/man/man1
    $out/bin/check_wmi_plus.pl --help | txt2man -d 1970-01-01 -s 1 -t check_wmi_plus -r "Check WMI Plus ${version}" > $out/share/man/man1/check_wmi_plus.1 || true
    gzip $out/share/man/man1/check_wmi_plus.1
  '';

  meta = with lib; {
    description = "A sensu/nagios plugin using WMI to query Windows hosts";
    homepage = "http://edcint.co.nz/checkwmiplus";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
