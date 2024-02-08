self: super: builtins.mapAttrs (name: value: value) {
  foo = self.someDrv;
}
