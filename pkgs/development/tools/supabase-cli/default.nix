{ lib, buildGo118Module, fetchFromGitHub }:

buildGo118Module rec {
  pname = "supabase-cli";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "supabase";
    repo = "cli";
    rev = "v${version}";
    sha256 = "kY4QTtmgi/uU2e86oQrLI9In3A0JykMr5Q4Glc96H6Q=";
  };

  vendorSha256 = "uV0pAK9TDrDplUJ0NkhG0mtAFhgBQmUI8seizDRxohA=";
  subPackages = [ "." ];

  postInstall = ''
    mv $out/bin/cli $out/bin/supabase;
  '';

  meta = with lib; {
    description = "Supabase CLI";
    homepage = "https://github.com/supabase/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ morrisonwill ];

    longDescription = ''
      The Supabase CLI interacts with Supabase projects. Currently, it can do the following:
       - Run Supabase locally
       - Manage database migrations
       - Create and developing Edge Functions
       - Push your local changes to production
    '';
  };
}
