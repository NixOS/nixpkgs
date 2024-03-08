self: super: {
  iDontEval = throw "I don't eval";

  futureEval = self.callPackage ({ someDrv }: someDrv) { };
}
