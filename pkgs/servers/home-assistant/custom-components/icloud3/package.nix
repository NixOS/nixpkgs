{
  lib,
  buildHomeAssistantComponent,
  curl-cffi,
  fetchFromGitHub,
  fido2,
  srp,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "gcobb321";
  domain = "icloud3";
  version = "3.7.7";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "icloud3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b2QFG3lz/LsUFMJw3R5D6wPxCoY/ZowctB4IOzarb3c=";
  };

  dependencies = [
    curl-cffi
    fido2
    srp
  ];

  # The Apple Account screens read `self.AppleAcct` before a login has assigned
  # it; see the patch header for the upstream fix.
  patches = [ ./apple-acct-error.patch ];

  meta = {
    changelog = "https://github.com/gcobb321/icloud3/releases/tag/${finalAttrs.src.tag}";
    description = "Device tracker for iCloud devices";
    homepage = "https://github.com/gcobb321/icloud3";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
