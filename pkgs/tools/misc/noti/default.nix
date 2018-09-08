{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "noti-${version}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "variadico";
    repo = "noti";
    rev = "${version}";
    sha256 = "1chsqfqk0pnhx5k2nr4c16cpb8m6zv69l1jvv4v4903zgfzcm823";
  };

  goPackagePath = "github.com/variadico/noti";

  preBuild = ''
    buildFlagsArray+=("-ldflags" "-X ${goPackagePath}/internal/command.Version=${version}")
  '';

  postInstall = ''
    mkdir -p $out/share/man/man{1,5}/
    cp $src/docs/man/noti.1      $out/share/man/man1/
    cp $src/docs/man/noti.yaml.5 $out/share/man/man5/
  '';

  meta = with stdenv.lib; {
    description = "Monitor a process and trigger a notification.";
    longDescription = ''
      Monitor a process and trigger a notification.

      Never sit and wait for some long-running process to finish. Noti can alert you when it's done. You can receive messages on your computer or phone.
    '';
    homepage = https://github.com/variadico/noti;
    license = licenses.mit;
    maintainers = [ maintainers.stites ];
    platforms = platforms.all;
  };
}
