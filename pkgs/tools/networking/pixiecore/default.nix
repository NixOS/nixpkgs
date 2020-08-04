{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pixiecore";
  version = "2020-03-25";
  rev = "68743c67a60c18c06cd21fd75143e3e069ca3cfc";

  src = fetchFromGitHub {
    owner = "danderson";
    repo = "netboot";
    inherit rev;
    sha256 = "14dslmx3gk08h9gqfjw5y27x7d2c6r8ir7mjd7l9ybysagpzr02a";
  };

  vendorSha256 = "08n3m6fkwh8jmmzky3ygij4gxlcqidqk5ywi8ki8bkyzzs2lqaw7";
  subPackages = [ "cmd/pixiecore" ];

  meta = {
    description = "A tool to manage network booting of machines";
    homepage = "https://github.com/danderson/netboot/tree/master/pixiecore";
    license =  stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ bbigras danderson ];
    platforms = stdenv.lib.platforms.linux;
  };
}
