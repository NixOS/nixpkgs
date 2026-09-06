{
  lib,
  mkSignedPackages,
  autopen,

  uefiSigningKey ? autopen.testSigningKey,
}:

mkSignedPackages {
  inherit uefiSigningKey;

  uefiCertificate = autopen.x509.mkSelfSignedCertificate {
    name = "insecure-test-uefi-certificate";

    signingKey = uefiSigningKey;

    certificateParams = {
      purpose = "code-signing";
      commonName = "INSECURE TEST CERTIFICATE, DO NOT TRUST";
      notBefore = "1970-01-01T00:00:00Z";
      lifetimeDays = 1;
    };

    passthru = {
      signingKey = uefiSigningKey;
    };

    meta = {
      description = "Insecure test UEFI Secure Boot certificate";
      license = lib.licenses.free;
      inherit (autopen.meta) platforms;
      teams = [ lib.teams.boot-security ];
    };
  };
}
