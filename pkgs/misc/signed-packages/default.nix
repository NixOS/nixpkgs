let
  autoCalledPackages = import ../../top-level/by-name-overlay.nix ./by-name;
in

{
  lib,
  newScope,
}:

{
  uefiSigningKey,
  uefiCertificate,
}:

let
  inherit (lib)
    extends
    functionArgs
    isFunction
    makeScope
    setFunctionArgs
    ;
in

makeScope newScope (
  self:
  let
    # This allows packages in this scope to take `uefiSigningKey` as an
    # argument without leaking it outside of the scope.
    withSigningKey =
      fn:
      let
        f = if isFunction fn then fn else import fn;
        fArgs = functionArgs f;
      in
      if fArgs ? uefiSigningKey then
        setFunctionArgs (args: f (args // { inherit uefiSigningKey; })) (
          removeAttrs fArgs [ "uefiSigningKey" ]
        )
      else
        f;

    private =
      extends autoCalledPackages
        (_self: {
          inherit uefiCertificate;
        })
        (
          private
          // self
          // {
            callPackage =
              assert self.uefiCertificate.verificationKey == uefiSigningKey.verificationKey;
              fn: self.callPackage (withSigningKey fn);
          }
        );
  in
  removeAttrs private [
    "_internalCallByNamePackageFile"
    "callPackage"
  ]
)
