{ lib, bundlerApp }:

bundlerApp {
  pname = "rake";
  gemdir = ./.;
  exes = [ "rake" ];

  meta = with lib; {
    description = "A software task management and build automation tool";
    homepage = https://github.com/ruby/rake;
    license  = with licenses; mit;
    maintainers = with maintainers; [ manveru ];
    platforms = platforms.unix;
  };
}
