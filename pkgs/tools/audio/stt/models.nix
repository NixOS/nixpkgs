{
  fetchurl,
}:

{
  english = {
    # https://coqui.ai/english/coqui/v0.9.3
    scorer = fetchurl {
      url = "https://coqui.gateway.scarf.sh/english/coqui/v0.9.3/coqui-stt-0.9.3-models.scorer";
      sha256 = "0M+SarnKtUqKfXAAO5MbLWLr2RBe05LR7JyEACmGd5k=";
    };

    tflite = fetchurl {
      url = "https://coqui.gateway.scarf.sh/english/coqui/v0.9.3/model.tflite";
      sha256 = "Coj5j/Fcm/dgv32gNbna+uJA5+sACvN2+H4FKq4zEgM=";
    };
  };
}
