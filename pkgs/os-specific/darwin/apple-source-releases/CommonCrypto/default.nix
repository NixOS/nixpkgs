{ lib, appleDerivation', stdenvNoCC }:

appleDerivation' stdenvNoCC {
  installPhase = ''
    mkdir -p $out/include/CommonCrypto
    cp include/* $out/include/CommonCrypto
  '';

  appleHeaders = ''
    CommonCrypto/CommonBaseXX.h
    CommonCrypto/CommonBigNum.h
    CommonCrypto/CommonCMACSPI.h
    CommonCrypto/CommonCRC.h
    CommonCrypto/CommonCrypto.h
    CommonCrypto/CommonCryptoError.h
    CommonCrypto/CommonCryptoPriv.h
    CommonCrypto/CommonCryptor.h
    CommonCrypto/CommonCryptorSPI.h
    CommonCrypto/CommonDH.h
    CommonCrypto/CommonDigest.h
    CommonCrypto/CommonDigestSPI.h
    CommonCrypto/CommonECCryptor.h
    CommonCrypto/CommonHMAC.h
    CommonCrypto/CommonHMacSPI.h
    CommonCrypto/CommonKeyDerivation.h
    CommonCrypto/CommonKeyDerivationSPI.h
    CommonCrypto/CommonNumerics.h
    CommonCrypto/CommonRSACryptor.h
    CommonCrypto/CommonRandom.h
    CommonCrypto/CommonRandomSPI.h
    CommonCrypto/CommonSymmetricKeywrap.h
    CommonCrypto/aes.h
    CommonCrypto/lionCompat.h
    CommonCrypto/module.modulemap
  '';

  meta = with lib; {
    maintainers = with maintainers; [ copumpkin ];
    platforms   = platforms.darwin;
    license     = licenses.apple-psl20;
  };
}
