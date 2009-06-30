{cabal, tetex, polytable, regexCompat, utf8String}:

#assert tetex == polytable.tetex;

cabal.mkDerivation (self : {
  pname = "lhs2tex";
  version = "1.14";
  name = self.fname;
  sha256 = "1667acce394a0d4852f8ad07fa85397e43873fd98a219db794e4773883288687";
  extraBuildInputs = [tetex regexCompat utf8String];
  propagatedBuildInputs = [polytable]; # automatically in user-env now with cabal

  configureFlags = ''--constraint=base<4'';

  postInstall = ''
    ensureDir "$out/share/doc/$name"
    cp doc/Guide2.pdf $out/share/doc/$name
    ensureDir "$out/nix-support"
  '';
})

