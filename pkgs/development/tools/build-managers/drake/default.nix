{ lib, bundlerApp }:

bundlerApp {
  pname = "drake";
  gemdir = ./.;
  exes = [ "drake" ];

  meta = with lib; {
    description = "A branch of Rake supporting automatic parallelizing of tasks";
    homepage = http://quix.github.io/rake/;
    maintainers = with maintainers; [ romildo manveru ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
