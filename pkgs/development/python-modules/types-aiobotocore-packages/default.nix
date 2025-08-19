{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      disabled = pythonOlder "3.7";

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ]
      ++ lib.optionals (pythonOlder "3.12") [ typing-extensions ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = licenses.mit;
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "2.23.2"
      "sha256-lRW+1h47u78SeFlV6g85VUeTWcrD+35tyvfDLW9PBoo=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "2.23.2"
      "sha256-dD41Uwz5+RvQ7eUm+FqMXrZn8M7zP5FSMuSh77E3NGE=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "2.23.2"
      "sha256-/RCJBWx6BNQRAAQ9NU0C4W7kImYXL+nvlMLziZ0XKKc=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "2.23.2"
      "sha256-9GbwI5+x58e/3Ib3dP60Ynerp1s5HX84+xQGU1qIlVQ=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "2.23.2"
      "sha256-sI9rqtX3f5VhaZ1sErcDIIi0AignzNXB6RWjC18Ujd0=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "2.23.2"
      "sha256-D7C4ccCxUJ1HAxTtPiaMNpaaT8uvfGwrlvSXwsRIk7c=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "2.23.2"
      "sha256-CCN9H7aK3FuLVYvy0X1c7nA06fkLYneJE/YEBdsPKis=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "2.23.2"
      "sha256-uYV6EQE37w4+8OFFKCbpBwNbGfItl31ylVN7/YjsMgU=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "2.23.2"
      "sha256-bv+Q9hxNW3tcxAKXbPK5m3KHl7Ismgc8J548ZPVlccs=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.23.2"
      "sha256-iXT2cKSE4mxIVv64kdsCWVANeatMQHqBE/mEUkct/QI=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "2.23.2"
      "sha256-nZrB3Sb1yEhF/jWah5Jucwv4SqpF5QGIodHDIdUxfPw=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "2.23.2"
      "sha256-z+zACz2w0ES+ruSBIukDwKOHp4zEgjoK2L8wnn5OvHg=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "2.23.2"
      "sha256-pticQtJzTeXXI+C1QDd1J1C5pYvkBQ9KCzMJPQgld9M=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "2.23.2"
      "sha256-6UyXmjLPPHUYAq7+yFKgppn8YpJcZysRnI5gqimYENk=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "2.23.2"
      "sha256-DpQHpXC3YVMb4jLCRjFi8HL0qUn/nP1g9vqYl/bNTE8=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "2.23.2"
      "sha256-xR44BE0eqNYtQhfZhoo7BpOBgEAcG3AAIR9nJh98EPk=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "2.23.2"
      "sha256-BohE1I2Y8lqc6lSRYaDBVhSata1TUT9jXj+KfFBwt70=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "2.23.2"
      "sha256-iT9gABIcvfCudtFZAmsre0i+af1a/XbuSS+hN90mMvM=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "2.23.2"
      "sha256-FQ/AdX/BNcxvK3U/aWTGvcUKGS2b7OCfAVz+nnnUHXU=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "2.23.2"
      "sha256-nbn7ReLpicq215qSnvCl4Ls7tRAGRTyQxUztzVgKH3s=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "2.23.2"
      "sha256-0IuFzWZbBCowCrl543mf05opd96OKMsAxChRqS2Dk5A=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "2.23.2"
      "sha256-PKv+1kd4gK8TDbi+fcFh9XlFtsUmA1MGShpbur4VNCE=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "2.23.2"
      "sha256-pOC9LH6DSLbzCv4VDjcD56DP0m+VfCa6/ijEuYgCszQ=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "2.23.2"
      "sha256-gnUBYq0R0Qgn3tnB0ifjUsVgD30LaIg1RbyiLKXGacg=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "2.23.2"
      "sha256-eKLyLF++seWkmP/7J5nVXeUt2E7X3aUoYAq4FlbBUMc=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "2.23.2"
      "sha256-kxYExGYPSd/p9cJfgI/GRZw8x4QAcTBJI+N/BTezh1Y=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "2.23.2"
      "sha256-hCtbxzZFGvKyTpO6aMl+u9OSfsvaGP3Il7UtC/voMWs=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "2.23.2"
      "sha256-ZPPqzA+ad5kX8RmuHgFSRu9CEexf7XNctP+W4RlYBLI=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "2.23.2"
      "sha256-4jKj5Aab3i0j0JTn20pxy/E4SUFHIwh2vzEN6QEMMg8=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "2.23.2"
      "sha256-4NImInnNG6lduC5jG38c73uB6Xmx5Nvv5LNFTTmVzH4=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "2.23.2"
      "sha256-kf6dZjECxcde61Ps7vKmcBW8CIiWZSiIMo6pXQyIyus=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "2.23.2"
      "sha256-0EEp3iOFjKFG51dbXzaGInqm4EncTqWLUl8yfIUSpgo=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "2.23.2"
      "sha256-koF1ALOGevT+OfJauz2+hLVuWVGIdSfQ97Vxc8YdiNg=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "2.23.2"
      "sha256-/14rRleiCat5rG6J0vkvfjSIMaZHxd2R6LkXV8lb4nY=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "2.23.2"
      "sha256-1mppzt5UVvRKNhvIi/q2tvyJ5osAmaKyEEv0vQbNuVU=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "2.23.2"
      "sha256-69K69vJ5xI7KOXg5KVWfLaL+PplzBnimjd+LbOjZFq0=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "2.23.2"
      "sha256-mOk0h08g3qqqnQbMQLeF8qWc85AZUl74Ow55rMEy8kc=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.23.2"
      "sha256-TjxkeGWHWBBf0gvlBMqksdimkRsqGIt2T8Sie5UvIWI=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "2.23.2"
      "sha256-mvGKopptLyXOsMeK1sBPJg7bXMwkTeWztKYDELpnjWs=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "2.23.2"
      "sha256-oyKVa4IoVTOU3CzpbFNctwfswGsNmCgHPDuo4KQBjeY=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "2.23.2"
      "sha256-qpXB8K/YgiGSF0erKot/IElM2+MsiWDEkAI+e3A+J2g=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "2.23.2"
      "sha256-brW5pdH+L7MThUjbyG0Qqbsoifd4FnYmyU7xdZiYMP4=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "2.23.2"
      "sha256-33DduyTThEWXQR5ho1GwzPcUH6bceRGmOw2pZIt7y7o=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "2.23.2"
      "sha256-Cc/7gQ3xGsv95xZNkq+PpAB9iqsEGY+UbGZQuOCILGQ=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "2.23.2"
      "sha256-Q/b9E136onaZaKynohGHGeTuC+B1/53Dzz4wyiyni/c=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "2.23.2"
      "sha256-iIvIoKq4lzmMUFWpwomWRIQftMJ9jr/YExBupQNuLTg=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "2.23.2"
      "sha256-7JcjLO+VSEPzn2WalspvVAGIWZdH9MdMHSNovCQht40=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "2.23.2"
      "sha256-xJe6SMVNVN0Gf/ntOU6jWyS0hJU0NyZz76XHkKFNlcs=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "2.23.2"
      "sha256-FsCsd4J2+vRDR4d+R8wZ6XJvqLs3aE5bWCCUztvvmaM=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "2.23.2"
      "sha256-hjDrMZLrxBPQB92VAQQhO16CcH19whNKDaDmAtVy7q8=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "2.23.2"
      "sha256-v42vIMJigatiYTVClLaPyvQvekxIyCFdMkyrGXQFbZY=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "2.23.2"
      "sha256-RQgvqeSXrw16Zxf1UuOc7OUJBEcdqwTK0qRXaiXo9Do=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "2.23.2"
      "sha256-oa83uEuVUVtkC3wgCZbyUVfRzoUKDHcXn1TKLlvwSGM=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "2.23.2"
      "sha256-m1RDaV5UdprjSagMAWF+Sl0CWbgfkbdio9PGhZNDHwM=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "2.23.2"
      "sha256-dzV7QcGNfH6wbqeAht9dZcnws/TQpSBPxOUPiVsPxkw=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "2.23.2"
      "sha256-gA4NKHQ5sm6epHEGn6fjT1s9SeBmwY5QiRIjUY8gXLs=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "2.23.2"
      "sha256-KUvmATsHPeaSY2YKvBDcdShT9tv9QQb7qZwvtw2lZB8=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "2.23.2"
      "sha256-/6Y2qianxhFy7FRcNEoRwkjmVCtC50vlEQcEdj5nnpY=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "2.23.2"
      "sha256-k0udsa5yu1tH1KdfsC+S/lm+rBXxnbeH2NYoTqxqoOI=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "2.23.2"
      "sha256-DWWRZ2LeE7hA9R7zj52q4De6q5/DvG9f/w1C6HtEVvs=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "2.23.2"
      "sha256-3b1XHUtEKi8Aqxw93kj5uboGvepzMUzf757OQTCJQW0=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "2.23.2"
      "sha256-TqPmC6VN/Q0Uga5iWzvfRuWnyjgkKdhLzMqeb79CtGc=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "2.23.2"
      "sha256-kCIiIFAQYZwKI7dIH7pGsvc5EI5xRupasSvockzB0OQ=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "2.23.2"
      "sha256-5IpmJ9cLPZbI74u/pncFlFxKRRwexY3UyR2nmwwSHPI=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "2.23.2"
      "sha256-wP327TnG74TA1zKRYXgIoNqCjL5CLzovounnIllEeCQ=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "2.23.2"
      "sha256-vsD8SfbcM/KHefMZLri6WLi2ay38XqjTZeigDVp7ThU=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "2.23.2"
      "sha256-IE6hqrkyfetjf336F2ets50fj/xJwU/dRG9LnfdeoNU=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "2.23.2"
      "sha256-MgZrWQaQGfHSNsiVPKkbTmsEZc5OnLhBH7DTURF/Il4=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "2.23.2"
      "sha256-NMhgEqy/ooPFu0o+6xXrV4JMwnojkjGU0hI78tsyS3U=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "2.23.2"
      "sha256-J/HR/gDb5cxuoln56EjjnzDf+7+H9dJgL/lGqWv3bkk=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "2.23.2"
      "sha256-q2kun8tyOa20gyds91T2zslj1/UF98+q2AmEPjokKaw=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "2.23.2"
      "sha256-/JD+E7IWh79eChZstt9iw1OnMIP54mCwxKGCc/SlK3c=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "2.23.2"
      "sha256-FUP3QrecVm8gT7KC5ROXIzAuQK89llaG7PaBiOGm1FA=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "2.23.2"
      "sha256-vead9IBLIfcMl+2JJTg1GnFot16s9LnKaczteryKG2E=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "2.23.2"
      "sha256-fhDaAsgZLWAOi7WxZdVXiaS1QgnhVoPE9wH3tHgFmOk=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "2.23.2"
      "sha256-FHg6VLlONMr/RwnAzXo45nr4XSu1TkAwUhn2cd1SPPg=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "2.23.2"
      "sha256-YtKiKULuUK6KC6ZjQ4xmfpCOBquTi8r9ClsJ6S1spVM=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "2.23.2"
      "sha256-altpqGxtN42mCqk4bEpO9Sm+9wCsMwBDKKAMGldOrvs=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "2.23.2"
      "sha256-7HgObtMuk22/YyxFTjqQOtMNnM8Wb6wlS1MAt2CtXUQ=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "2.23.2"
      "sha256-bFBAxhHoJ61VC0TX/XFyAA/gtKlRe50ljEPF4LhuMAA=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "2.23.2"
      "sha256-sdmd9zirohBCtz3BrpTt0ThcseFRVGgLkgq509gOxV4=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "2.23.2"
      "sha256-GFLKEb6yk8PL90WFhTICmKeGbjqf22F+19X5xQWUU8k=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "2.23.2"
      "sha256-njBIEQBs5cx9jDo6fZYKyBiyr/UL3puSkGd2fEDDdlE=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "2.23.2"
      "sha256-seNkGXJNpaxJGwLsYNsy879g8m5GVLUdYpILVgvHjJw=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "2.23.2"
      "sha256-6COs0A3r66wtnVgYJRS5lihjLVR//6N8kOTzbCIEkFI=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "2.23.2"
      "sha256-Fqnn/1jKVMPc14Hwy0cgoNcBh1AeXd5CbWXI7+rRuvk=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "2.23.2"
      "sha256-INOhvvLfQRYesMcKByKpTQRLTskSEnjoG/DTbpv9Ba0=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "2.23.2"
      "sha256-XcMLmnSha4Y5Px9XFSEu3K+v0im6eTLdXwmCDjeqQYI=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "2.23.2"
      "sha256-z7vr+UHi0ILfdfkncwoiJ4wsvGM4Z5SAEIoavj3trr0=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "2.23.2"
      "sha256-Yz5nbQQ6AQWrbPGN7u0mOwcx3U+nec/gL+2cygWBIh0=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "2.23.2"
      "sha256-Y/TmbgiaAIz36SJvPqtuB9nX7KRusO4eh2Zjtbdn7FE=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "2.23.2"
      "sha256-dYQgNhsLp/8VJ5q1CiHawt4/xuQ7gwVC7OdIMnyME4A=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "2.23.2"
      "sha256-3zEsTqF3fsrM7mvV279JyPc5qVByf1LzIQGFYceerpQ=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "2.23.2"
      "sha256-+NbJROoovjnrsCaR3ggs70cbBJFJvdjKIDhzkMfKNIE=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "2.23.2"
      "sha256-GOQu9WTLnES9etpXfUScjySKD4dSL9fLo3D0S7ExHHY=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "2.23.2"
      "sha256-FnkkKFzgQTdZwCIyWZm6taKErY9nWqctw5/rY+IZXes=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "2.23.2"
      "sha256-2qxyD2S+UAR1Q3ZX0g6VqBFgqVXo/mPo5eFbNNc1G5A=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "2.23.2"
      "sha256-TTw51HbpRi5nVcAkHG9kPLBgW4u74IDa3HCYV0RX9ZM=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "2.23.2"
      "sha256-OHJwBgblvdj3+lN7EfvczE+CT5eVfJNpPGJoPU5iddI=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "2.23.2"
      "sha256-4pVG1Vmmp+lEEQGc9uNgR0ff4eKBP2Zrk+HkFpgFawA=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "2.23.2"
      "sha256-8L3K/XwW3W4kbTt8niYtO4z8Ail66A4aDGN6yY/u8jI=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "2.23.2"
      "sha256-r0i5wrvmcYgIxO1NrVAEQN14jNZUIaSfxANGOF0A8zQ=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "2.23.2"
      "sha256-xz6kOKIOFfieVC0e0DrKpSr2eGFl+f3UmI7wUZZKiLg=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "2.23.2"
      "sha256-RelW/a/LofzAbMgOdnYiv+DL7UEJJ/wgxfCMqasDdNU=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "2.23.2"
      "sha256-0CAilMg7Fgodmiy+szLH+pW613sh9JAtZIR8IbvIFuY=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "2.23.2"
      "sha256-XlJykcAWkelakJH5wh+/fQRwce+ojXpbtRdf+qO2GZM=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "2.23.2"
      "sha256-g+49mKJejMj4tpAvvhgG0PdAk4AfzkEZo1zsGr9JFno=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "2.23.2"
      "sha256-6fCDofpsbgAqZFw28b9mz4fAsUX51+IAeuD3WO7LuO0=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.23.2"
      "sha256-TBI0mFGKAnzbWjkrmLS6Wmk44P6VgnHCBKBEOsigkW8=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "2.23.2"
      "sha256-/2cRU2y7741hxzF1BtjmivBoxbJ42jktcbd5VSAf/a0=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "2.23.2"
      "sha256-tZZla1J4nyyde0kVXoztUnFqINRJiB0EPehzabpmDHM=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "2.23.2"
      "sha256-1PrCOWQ64PR9rloq/YvCkblKyg1CVnzHQmG49IG6Fp4=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "2.23.2"
      "sha256-Vxzd0FsaWPtpVdH+WH+VwJjMvUDirrqHuGcIZ2ENRkU=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "2.23.2"
      "sha256-vha16t+XLCpcICch9PCeRKkUMZW6bds9RSHGIMb9H2g=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "2.23.2"
      "sha256-w8kK9ZmeDVox+BsTkhbH7r2hHZJBXmORQI3tHdqs9JE=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "2.23.2"
      "sha256-5qKswPbIuItDROww4XBUq72G3zOdYEDUHd9Iw7qSb6g=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "2.23.2"
      "sha256-68Fd1Va78bd9KZQwwWs0Xj8Fq10Je71hKouuEtFRKwM=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "2.23.2"
      "sha256-2i9goFj1msqtZIo+Yem05Qt+mHN1o4puThgdlVpzyrI=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "2.23.2"
      "sha256-Jfx+sO74F3GA+/gn+eIDD2HAFBmpCRurzFrzsPw3H0s=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "2.23.2"
      "sha256-AjmJK7KuxZ1sHYCH4U2igkmqhAFNgsg6tfFESYDZtro=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "2.23.2"
      "sha256-Ok+9I9SL77DxUondcB2ukg+qhMZPFRIS2hFm9OaA1mA=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "2.23.2"
      "sha256-mKQG4aKb5xn+r3s6eJpBPX4fwWcetOaMrJPXq5wERdc=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "2.23.2"
      "sha256-vsrL3JygyO1jBCXjpGbQQqhXN+Bfq9OX0Nq5703XAjc=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "2.23.2"
      "sha256-8/JC5cmWqpt3iiraS7AkDRuy6I3WbQvGpT5rBsuN/rM=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "2.23.2"
      "sha256-TqVmE7agH18iGJixn3vQ7XMQsO3ApG49kIwx+CkZO1E=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "2.23.2"
      "sha256-DDRFT+cUhgsw9t0Ch6nwkiV/cuK0Wn4LEuCQDe6WC2s=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "2.23.2"
      "sha256-XCTzrtmjqxS9WZBsoMcWFomdmsUqHoW7tACJ3Zy3vEg=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "2.23.2"
      "sha256-n5ljDZ7yVn2pefKLXRFnU2+bc3bGSSOD1PAYXY8kwG0=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "2.23.2"
      "sha256-YPIO71oJXGqiGu3AvNq6+ilHUQPkDpRJZLr+8nj4ecQ=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "2.23.2"
      "sha256-+OoOin6DK3wwK2QnSR+E0efARuNxRfQZ7KWY/8Sn3Eg=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "2.23.2"
      "sha256-Hk1uistHevHtQR/BwT5jPNs66pYhYqeh0nVvOlorEb0=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "2.23.2"
      "sha256-t07+2j3G39YliL+wmach/UINxe0+di2MS2pHQDnMMRI=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "2.23.2"
      "sha256-9UT5gBtKSGSbYwwshQUvZpDGJCg4WwvO1qnDKBfciLw=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "2.23.2"
      "sha256-9tBAAec0Ht5gyCZczmotb3k4V0XHJkVIRXnemF9tbn0=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "2.23.2"
      "sha256-3T8Y2/z3bdlaFmIg8/WB3EcKUxu3ZYpJIMw3+k9bpQ4=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "2.23.2"
      "sha256-jzIEVT/h8U+s14S757sFYjDjuUjk7SDsHKHu3ULHiLI=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "2.23.2"
      "sha256-VpnMibAW10aHtHnEHRQt/ZIGwXwzwfguZlVO69LSRok=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "2.23.2"
      "sha256-8HcMNigQAGfKq2YTxnAVZm0Qsux5GfoC4igDfV2K84Y=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "2.23.2"
      "sha256-ijOqQJzQdTVNZhudaWQWhjv7PpLZO0jr9pmrtHxS1Ns=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "2.23.2"
      "sha256-vwi3s8fFxuMK7fSrWwQP772B/Y9cKJXLMiufCPEd9nM=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "2.23.2"
      "sha256-f+GEEmigWz4VS0XDhvrWHxWRHpnMG+uGcUnSBvznQuo=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "2.23.2"
      "sha256-/nMZ4zhYLfWo86I5NvoxEyHqxFpNISTnMqhBtDfv83g=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "2.23.2"
      "sha256-N2vVCGxSopkmbE5mAQRsYImncxIFimZXTCDGRfDzojI=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "2.23.2"
      "sha256-s9c+lFJ8TPGhi2DWVJ7sQ2tPEuJ4ML1DtEhMxO3EMvs=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "2.23.2"
      "sha256-h6dTStOqtygfQZtZFLsxToBPyl7vmgeRDOgZeu5Tm7Y=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "2.23.2"
      "sha256-7kOhvR27eH4sx8/bkS0Mj1d40rXFT13ZFD0lXwOo9jQ=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "2.23.2"
      "sha256-rEEQ9U354WxFAF8daukNRzSC/7GC1iCmEe+5MrhTUGM=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "2.23.2"
      "sha256-kPG2ALQyKPOahQj6c90S04H8B+928WWS8X8wMtHOA7Q=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "2.23.2"
      "sha256-9vr2itjH2kY0cwsF+EKCmXZLJ2e5CUy2PRSlwtFO5uA=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "2.23.2"
      "sha256-tquJaEq0/YXZeQUyFpbYuKwfh6miEAR00S717KM6P20=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "2.23.2"
      "sha256-oggwzvFnBYSfFuwIB6uUeNOT52aXmMGZUWtcRJXfokk=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "2.23.2"
      "sha256-TJfMUjbI1JnuW3mr/eVxLRxlvz44sbrECvXfv03E11k=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.23.2"
      "sha256-YrweZku7IAtXTl7NsFQE3beZ23/oOwxybxIaCAt0agk=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "2.23.2"
      "sha256-37Wg4t1NNOYdiPA/b1o5Ok73QfQjKR6mItl/8JZSrJk=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "2.23.2"
      "sha256-56MLx7Li/vrTHn4WJMo5Ooy725MlP8hDuIbP8nRHnLw=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "2.23.2"
      "sha256-BxUGTYq3yF4Sa3AMeqAS5HBuO8Q4PpX+GU5r3bS+1Xc=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "2.23.2"
      "sha256-9RD4qhtp19MOROR3bUGNEELwrEPovErq5nZimT222wg=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "2.23.2"
      "sha256-Kdmyx7vtE2BkzlCJ7TQ4y4bZPT1jJ1v02lrmZ9Bg06o=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "2.23.2"
      "sha256-Z6THQbu6vLJIRmt1LqTA870qGZSND8xK6eXzRPbz2io=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "2.23.2"
      "sha256-vUEUMb4h9jrPkTJM0nMawVlpIcrcSzATRX7CcaJeexk=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "2.23.2"
      "sha256-axiEU0UAyNtxQVc1PJSPAKj/yesdMoPliTqTkf0u+u4=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "2.23.2"
      "sha256-8t1VBLeq7BSsXoRr0eAFnzk2ibJna+3p+Z6TpjjG70M=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "2.23.2"
      "sha256-nz5QLZ8My3f/QzwtrUI5vl/T2HiQHbeVWu7mfa+6MxE=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "2.23.2"
      "sha256-mE0hxWyBRPpnDFPJaH2vtsrrrN6fQ2BkjB3xJbZoiNU=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "2.23.2"
      "sha256-qKsh3BV5Cf1k9f4D/69ZHlHoB8Ipf3fTfdyCAUN0M7g=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "2.23.2"
      "sha256-le19UtodR9jzTIbZXH/WbEZ9cXyKE/xpf5KdsN7Czho=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "2.23.2"
      "sha256-tc6vIZ8TKvaBtEDQcmQNI+e4RLt/tm+P3s19Ax9GRL0=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "2.23.2"
      "sha256-kl9Ka4q0o8LcS3+ln4Kq3iCpoIeBGroDL2WCq+0iQSs=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.23.2"
      "sha256-SlcYHrj/qNNLivkN71rvUL9Tt/MMorfxjz1ogLTA0Wk=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "2.23.2"
      "sha256-DhpJhnF29VKrtj+hvVaG+/o1fZF3SAQ5+fdth2l3tzg=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "2.23.2"
      "sha256-999zPvf6iGeQAvDS2rFHNW9p2bNLNqlVpEVIxwa+FjI=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.23.2"
      "sha256-pS/NXBo3MPrQkJzIrbyJCe+7hQGTXwF724NV4JXZMN4=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "2.23.2"
      "sha256-xMZFE/l4Bs8ekNY3qCoE5VmmGhV8MqY16lybHu2I7FY=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.23.2"
      "sha256-BW5ES/6JvheA9qnsEcw1cw0z3xWFfuRzsS8QDBQ4+UQ=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "2.23.2"
      "sha256-nQcAUFZeybb34WbGJOLOpu5/VoEDPXYo0wMvpQgK+ho=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "2.23.2"
      "sha256-1DryHMvJlL29ALd8Cbc8FXvx/+v+AzHk34sIpxZVmu8=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "2.23.2"
      "sha256-U0PMF7Ym7Lht152Qj0uKr0Def94x+Z04riTL/DWj0ik=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "2.23.2"
      "sha256-18PyTV75muSvs4oYBfKsEaQSra8KGUX/5p/b3K/CW5s=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "2.23.2"
      "sha256-9mxWTK9laXCmENe/B1WX1NliTMaCQydMgbjTvk4yOPY=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "2.23.2"
      "sha256-rTpdkh8y4W2M/NqbfFIvZQ+rf2gciZ+IvkVs60Qp/Io=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "2.23.2"
      "sha256-3+EW03CRG9TWVOm8RafVtFEZhH+Tkr89xW5ahtljHns=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "2.23.2"
      "sha256-OGjJcOwQ8eOvC7aKOCFixfzOnlGV4gEK67yhz3/8xss=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "2.23.2"
      "sha256-rrAoivy/jBQJEeQUJZE8YOlNPvaEft+xph3II0XNt6M=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.23.2"
      "sha256-xQwAiuZ3QoCE3bcDZN31fWSDZi/TdUzM2z5xCCsnbdA=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.23.2"
      "sha256-F60gr5vecjLvCHevXJO1aIH/c7S03forB5MrRBFniVA=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "2.23.2"
      "sha256-28+DecEGbDMwX/Mdmo3nIVVIh/q5ycj12CwuMm841FQ=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "2.23.2"
      "sha256-1ibAW8jrYtSDmfZkW5kmp7t46C+PqLGSdz9x2VGHWq4=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "2.23.2"
      "sha256-9MBRw/JahwyVzPDg02YFsIUYaRQ0CCRWP4KfJFit5wE=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "2.23.2"
      "sha256-Sj4gvNn9ZkIrPlJaBwCL6qnYhVSy9EhoLhf90SYCm2c=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.23.2"
      "sha256-n0rAIITRe+YUja7QOLr0b4+M7nGDJn8F2CaEPTsaIC4=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.23.2"
      "sha256-cIX0lvrmf/p/CvDvNeoUXe8Xs/ZIsncGIi/P37/QIcc=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "2.23.2"
      "sha256-cYFXKLaYPaPzy+n/bpwaRgvo0N5xuB4cKGZnIqwSz8s=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "2.23.2"
      "sha256-PZl/FzjoRNiFDU4+TjBwKEK1gBBwEgbNgLcWH1Dn4Pw=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "2.23.2"
      "sha256-BMMku2V/qPub4qLr3ldZrACCyAACOXKq0aCquI8bLvI=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "2.23.2"
      "sha256-sBmNx7Pqi8+0rBBUNwxub7lhgE97MvSpzx4FY+ILsm0=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "2.23.2"
      "sha256-itFFjnDvYkbbf8A+lW4oxa6TZKGioe46pT9vb6BZ/EY=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "2.23.2"
      "sha256-IYCr3ZoV9eibijHWX0vl1YKy4XMzS8RcxvsaBPoxU5Q=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "2.23.2"
      "sha256-ysySxME6brUqTS4wLkURvjdcofZQCe3V+huXTWgvEMA=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.23.2"
      "sha256-CVFRj0wNwT5WK/OURgDWuJruqqQcMTaaG6GHoVsEWBA=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "2.23.2"
      "sha256-fjEkRaAqhN6AfjjuVbcAL0OjqeCoq9NvbnHlB6f25/A=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "2.23.2"
      "sha256-CRle4rDOnM5TkzFL9AVTbtERPl+URsWXLgr9lQBu6Ec=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "2.23.2"
      "sha256-utkvcVYn7aj+wxSHlMg0rn28PYnixQc4Is7+KSAmmi8=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "2.23.2"
      "sha256-kuH+ofTE3mwRyZCbRvo/e2wvI0inDL+o3CZfKfXsRkM=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "2.23.2"
      "sha256-RQ4kOxg/PHq7wPxz9S1FVSxlWRfOxNFKORfVfzCtM3A=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "2.23.2"
      "sha256-I7neo0bWojDAsz0zBwIvfJVIRzfRiuRB0uiJBYj4TTQ=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "2.23.2"
      "sha256-EQgtCLfs6AjuloMvhkLlxJclgOx+CBfVB2FZBOtizFc=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "2.23.2"
      "sha256-v620OATZVx7y0ZkCY/XvtMo6jBaOf7rByEIRr3T30c4=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "2.23.2"
      "sha256-RNqXcEGGJsuO4jNl9zDDkB3GqAVrWsmnwgwBTuQutKY=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "2.23.2"
      "sha256-85eAmVjVV27EItse5Mmnik2E0V8mVN8mgS42xLpdLz4=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "2.23.2"
      "sha256-6lmVpW09jQqKdyTx9xavuRsEJSbWOmQ3hHltNk8eZ+A=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "2.23.2"
      "sha256-FY1XyeqBhWWr/aBGvzM8tgnhl0tPcjGze1AGrIEZso4=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "2.23.2"
      "sha256-fj3+loK/Xe4w/IrLeaP3nSYKlovjgiMoVUOlSNVP3hE=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "2.23.2"
      "sha256-Dv9yQ/85FVrH4vDR2V4u6nWRJVm0VdfUEoePbQc/ljA=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.23.2"
      "sha256-gGq6ebu6FbAlmEaYeEV2oQ4kkzxSs8aAEbuOgM6pBK4=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "2.23.2"
      "sha256-yqAQoFLYAkpDiAWPEi2xEglzeDM8jzNgIfPw3e3M8oo=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "2.23.2"
      "sha256-gdXq+JyqKQfWN38NEE3sPRfYT68hpEt6VxTAHwTDWgQ=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "2.23.2"
      "sha256-BErOEQwrtu+O1Su8kcUyRreHmo4xhbg1ropDl9DiYaw=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "2.23.2"
      "sha256-sHNIS6MsZTJnmGU6xNd1Qu23leqLVQzZK0B2UqoN5vg=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "2.23.2"
      "sha256-tky9YLOOpw7qA65qlOumWyXYHfuqEIDlLfkODDVRlY8=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "2.23.2"
      "sha256-j2KmiJzSb7PzrjJlDDLAiTztj8DBR8yl7vtDSb2Gx/o=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "2.23.2"
      "sha256-F20C5yf7s7b9UzFBQfL+wkKkD4w4iV+nfhTBOxxI2q8=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "2.23.2"
      "sha256-1ZowibYjjwPZxJ6tmxVvBFuuc7+A85hliWoZoXdqkDM=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "2.23.2"
      "sha256-2Mu2D6LUYNdhBAIv5VHtUeM24fc5MQpaR1cTBQZMXUQ=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "2.23.2"
      "sha256-ZLzPyqdJNNKsHdVRzYpCsGjuKfOeR+ONRBheYr/pI+U=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "2.23.2"
      "sha256-vL7QbSKkP+f5g7xFlfpXF1J6toxLuL2YtiT9EDX+CqQ=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "2.23.2"
      "sha256-MlrprOk7qJU9WPmwLP41NjWZqLS3sXIa8pGKaQF9+Yw=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "2.23.2"
      "sha256-KvTpXJEuzUnR0Y2tgtaCpkLpvrqnVmbD3L3Ac1tB7uY=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.23.2"
      "sha256-OFujKA1yPN9JWRKKBaTRqUZVWsShd2XhqWPBJ5fJE3c=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.23.2"
      "sha256-Ez3TEIPIVOZ4Wyl9ygC5adwLA7c4Rqi1CV5XNEQLFpc=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "2.23.2"
      "sha256-hWHud/4bM+uyEc9a8xEfdjNCD9Qq89ESnl2fRwL7N70=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "2.23.2"
      "sha256-pt3eeOB/ZdU/7XznzBNjbVHctgnR9eSaF8R4gmPv09o=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "2.23.2"
      "sha256-IIlmfn19zmloC8PSSwUgkBGsgoyHB96STr+Q17UeIfo=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "2.23.2"
      "sha256-KHQh8mRolYDc8bHpojTc/zGLhDBXG6r5I44AkR3uuKQ=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "2.23.2"
      "sha256-hC/qbhYJR2SVDBAbxcRGxmiTP4jJ9oxryJtZRlNZ7RQ=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "2.23.2"
      "sha256-BoEGBAzC+HN0pf1IRC3kSdQcmHA04CFHj6bbYDGEiII=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "2.23.2"
      "sha256-lw2XuCdj0EA5WV/xK4/KzugFcSXyN1bIJ6vdQZ+C5dw=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "2.23.2"
      "sha256-9u6KBY2LNfnON+/J1IHoJS2VFPGfKYDPKalxnGa0jwc=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "2.23.2"
      "sha256-q4VsWLcmnlXsDRpSk82vmNUbB3rvaT1wWGtYHLqPQ/Q=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "2.23.2"
      "sha256-SnUtXL7NfNYFmV6JcSHhW6cQE8Es6iOMV5cg9P3NL6k=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "2.23.2"
      "sha256-Oqj9HqjR1rcPVK+9zzDVtarmpspzLfF2/MASaCY+APo=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "2.23.2"
      "sha256-k1ZsOYPmD3WT/qnPvT92AlyimQEN06aInS5TA83ZXn0=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.23.2"
      "sha256-QSZjHkrf2//XGcj1zEvQyjt33v3kK35kRYI/kRH8WTI=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.23.2"
      "sha256-ZA8MboUbZDiy8toQrZe0IIhgtV3OkYIHPjJxoTtpBCc=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "2.23.2"
      "sha256-JQ7YmKZjYT8QhXQ71Aqcry1FwV3dagDjWcQyxcS01Z8=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "2.23.2"
      "sha256-DvmGM1PKfjgbnz5byq+YwXnG44Z/cVkIRWhGbbEVYJU=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "2.23.2"
      "sha256-VLkB7VAtuHn9gpMBfRiCXN3hW98A24mlPCtmsCfMwUY=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "2.23.2"
      "sha256-xXUdoSbbq1auaJyBq4Z147LcVW256M76/1LJz9sG/gk=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.23.2"
      "sha256-4Zbs1SynybFunfhQH+/kXcET4KbwBY8GUXuwZ0sL/WE=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.23.2"
      "sha256-C2t2633V0i1OfDL1GNPt5HMEoFuXMspT4SbYTP3sTKc=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "2.23.2"
      "sha256-LrnBajbP6B5trm0Ebd/Rlu4997tQ2V1qWTJ78FWD7tw=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "2.23.2"
      "sha256-cQ+xCOu2h+hCxH4SPX29wHEYZw/0zPZGdIWmEdbcYHo=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "2.23.2"
      "sha256-34okwB5Kxu58go/go+ePfjYI9WB+Qr0vtS7IWzSrvnM=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "2.23.2"
      "sha256-bj8wy8iW4ae74GAmDjzFDM6XgSFn7HuudjduyMpqaPA=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "2.23.2"
      "sha256-LVmnPQBvTIy7WFDTMWKWMwuosIwAEnqePaklqRNHH18=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "2.23.2"
      "sha256-8uyGssIcvC2aEM/1osGd/QxT7Oq1Hv5b/odPpIXEynE=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "2.23.2"
      "sha256-tyNsHjd/jrALXasfhX8JNklJ63zNZ4OiO97AyyW/yl0=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "2.23.2"
      "sha256-XWQPUghyV2npeQO09GvrLBU1+3+Z9W/RIwu0I7625MU=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "2.23.2"
      "sha256-l7GFbw2/x+Ob7ZAgKJ1eFCkLQLv1nMXC8A/uBamFpLM=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "2.23.2"
      "sha256-Jl3KBs5n+Edk4/iY8Oq2KO7ocaoCqZE83L94Si8g+g8=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "2.23.2"
      "sha256-ynDccEiN6+DPIcy+YgFTSb0crIMfCp1uLxBoevQacM8=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "2.23.2"
      "sha256-ybqLQWSddVa3WSaiuGQ1OQKG9VD71bvZ+fpcnAXczcg=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.23.2"
      "sha256-38Ok7Ugz1Y7xWoY1ffToO4TjX5Ai2qD4CGsyUG8ylto=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.23.2"
      "sha256-khpQA5VSeN09SH/0ycSoyRKuEWUbzevbhtSuuljvCeU=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "2.23.2"
      "sha256-aAgG+we4gKYIvOiCQjE9IZAXPHOzLhZt7w9iAQc1vXY=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "2.23.2"
      "sha256-qXNMbFyiKD6Ra46LBWebAzE/royjqrrgHJls2PSCs1M=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "2.23.2"
      "sha256-ABfDIOgE/6af0L4tcV15VaOl/8zhfLy3rGQakF/Bd4o=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "2.23.2"
      "sha256-C9Pkxa9yLUqEuSaQAGaHCzOQeLQDKuGQD3fNFbWhQZE=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "2.23.2"
      "sha256-W6BIeUuTi8QSbT4Ja9B0UBQ2YeC5YOAbjumrPBc3P7E=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "2.23.2"
      "sha256-fv8Pg1qhaigHqxyr9UimqwXuu3UeLxoFrzRnclT8nTc=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "2.23.2"
      "sha256-Iw1xkRzfuBIeOP6bohWiKFeL/odd3yuQxIfGovV/+ks=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "2.23.2"
      "sha256-e56DR0g48Vf5Iub8IFHOgCZA+W4ryZMnXeLZcm+Pk8U=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "2.23.2"
      "sha256-8BoIF42zH97jiQCWWkMHerWYtFybVI8/8VEtaspF44I=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "2.23.2"
      "sha256-tMpWWfGh39vE/q8dTekgS1DM/FCZ8EIV/QwMCSd8+CM=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "2.23.2"
      "sha256-7GY9uT4S4sJSoW44IDQCjHt7FZ3z3z5HjtklVP+tP0Q=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "2.23.2"
      "sha256-JitwKHs3dWtIEzPLs2E3K1ocjK+6V9ifYly4KHYKEeU=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.23.2"
      "sha256-rDLAQ0CmJFkovbX/aFuSvG2p43y5MWWxeZhjyRudjys=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "2.23.2"
      "sha256-6f+bHHgmCiFJtFDWpOHc48t3UdgVqOn0QgpZRBdGdMA=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.23.2"
      "sha256-bBhEDfJkcfpssFVozGDp81EWAf31u0Arw1k/7DP0OrE=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "2.23.2"
      "sha256-BLQdDCrPFGqXso6ZmC93j1sA4QWo78aW0bDpcRFBMkg=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "2.23.2"
      "sha256-ytMnM7y8UBrsLjFg8oibB6HcljtUiWSpx5397K2NtWg=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "2.23.2"
      "sha256-HPNsoVupHTLz3ng1kFk4f+Yo4uWB9SYsc6QUVq0GrBs=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "2.23.2"
      "sha256-obeU/yDoPkMREN7+VMDjpaz5SQXI99u8fjYhPx5jUKQ=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "2.23.2"
      "sha256-QcePY3cWP0VGqVvdAOC8E1BtCiJnLl4Hg2PWlFLkiw0=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "2.23.2"
      "sha256-JEAObIWiMvOk/rJ30ZerKa/c60mcyZpGOqNHorAme0Y=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "2.23.2"
      "sha256-bxLLaVaGkiFVcBxaiV8Vag/Pl/x2pSg73NvTeio2RS0=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "2.23.2"
      "sha256-HvxxDQK3RbYu5B6Ram/Nrb+vWTzxitPRL4Ul2+52my8=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "2.23.2"
      "sha256-VpYXbMgtozOfaSrhBAFjafSEvX309RcqItUvVM0d6lE=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "2.23.2"
      "sha256-OQlkvKJ3ysq3EHS/dZ140vsEGlrdmP/JyRZlzF7RZKM=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "2.23.2"
      "sha256-moaKI/4wxP1jtuUiqi6APyMLLXAQza/hcZiXxaEn1aE=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "2.23.2"
      "sha256-KHlbTbpS5qGXxbCH4Dl+86jpW1wQIrELJgDAnAeZOII=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "2.23.2"
      "sha256-6IhUJJTGcEjr4739JSacTFOmwzUv6dkTJ9dB7F2PtCI=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.23.2"
      "sha256-m8qcxSftCo66f3lZrMXAyVEDtVP8Y2DzKFmTMbSbtRc=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "2.23.2"
      "sha256-2+EHVE4zLIDT9ZHIwaiSHV0G+dt4NNeXlAgOHbftPJo=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "2.23.2"
      "sha256-Bmy7lEEZcJ1RiEqy1usFUskGlHdnAdU5+a3ASM6fNPw=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "2.23.2"
      "sha256-cVlYXOvK1ovaAzn3YYWU8ZvW6yHd7IOUqIcpAgxyipQ=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "2.23.2"
      "sha256-M8l45iCeZ3Rq4Ok6iVE5wb96oOF/m6h6PP9pDTXQJWg=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "2.23.2"
      "sha256-O7LGJ9RLGc7/1+C+OhJG2G0u6FyrzYnriAA7ESLdKpE=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "2.23.2"
      "sha256-4yDLoGFAOHyYFa6FoqwNnA7A3OirFCyTiXNx7BYcDKQ=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.23.2"
      "sha256-bjW6LqsZ5i/DLPFlH8kGItnpUw9yn+/Z1VeNEs39k8E=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "2.23.2"
      "sha256-2GOOg1R7phu2w+pS6DnqOWwnSBd9pbCouBqruz1p8VY=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "2.23.2"
      "sha256-WIIZldfYq2+QEszAiXx5+OaSUZnEpihpQAjSR/zvttg=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "2.23.2"
      "sha256-sFt/Tk5pJGKUf1FzLPzh2MaV3s48mhS5Z45DB1cc/7g=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "2.23.2"
      "sha256-Qkt/diu4NvIqErOrbB6V8Gut0mFT8GFmPEmeYSV7AO0=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "2.23.2"
      "sha256-VTNG6NymkJ6okACKCzjBJKoN9+RgxXP92tQI9CcKGYs=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "2.23.2"
      "sha256-bGGJUoS47GS0rQ2+pUbJ24oxuTT1tzbXBLjTPAfnq54=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "2.23.2"
      "sha256-LDce4hukTKGAubLAgAO6MYRPxPZU0BPB9reKwsUFlpQ=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "2.23.2"
      "sha256-qPLEJcTarmBpzTzrDZmhXuO3MX/btewKtY4HrZDlZiM=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "2.23.2"
      "sha256-ID4gwlyyrbdZubDHvlM4ttCT4gBuY6O0Wairt5dwbo0=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "2.23.2"
      "sha256-F83K8WvDTK/ATIH+wGH5vz07DOBdedy+x5sUbcdrdWo=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "2.23.2"
      "sha256-KKRZZj8WMN5Arfl6MOvp5VEHWUOcoAMyeZTU8SrvkcE=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "2.23.2"
      "sha256-SNephRpMQbFRdPIFJg228CIbYXPmFP0VQBCMt6o5eSM=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "2.23.2"
      "sha256-5AfrT9iNcHdMuslQ1Yt+r/zPvKn3FAPcgjOV4hq7XXE=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "2.23.2"
      "sha256-1Pbxy7xiqYQaEnukC4A9dfdLol9C6FLdQ6lFbYrjUHU=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "2.23.2"
      "sha256-dM80XCLpE6Ce0YhI+CrlmWQBZaq1WyAh7dc5o5d7PD8=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "2.23.2"
      "sha256-rXgza6VCCJFUVtpRh517lHmpEw1SJt/FJ/hCn/pwp0w=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "2.23.2"
      "sha256-OD06lxrb36mlg2byV/LWOUrtH8bn50qQ1oZVMgTvv8Y=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "2.23.2"
      "sha256-tQo5/c59YE49ByNfOUvjU1it4voa46RPJ/UgfTeEvpM=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "2.23.2"
      "sha256-f4dp8RXYWTIyEpLRK2j2JT8YuDDmcFfoM1F4WSVliAs=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "2.23.2"
      "sha256-od2tkolG3+aJq6b6e4ZCk9K4v1JwV9fEtIUdGaE2qvU=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "2.23.2"
      "sha256-m9GaN2G/dZdIe9tPD5ZsBEkpvjzxQ29XHRCaNoGW4SA=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "2.23.2"
      "sha256-Ift2pv89c4Mv324BGFFFNHhys8e5/Y04Bp5cuKdNCL4=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "2.23.2"
      "sha256-PEkelbZJGFEF802Zth53Eb6LQpMnrD0g+Y7MywqiYP0=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "2.23.2"
      "sha256-WOyuJUQp4BkFpBqBNdHsRIC+OY1hNVUZN84tPUpqjDE=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "2.23.2"
      "sha256-cxYoHczI9Sr62CsHo8+SjpbkzmYcA9lRH/U98kaKaIw=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "2.23.2"
      "sha256-rYs0eoxjU/PtYOF2ADgiBd9O8mLXMT/+6WLprfdbzCs=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "2.23.2"
      "sha256-hsgme2tduhW3eF/6PIUTyub2lEGHGr9+HOU/kI0zpnk=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "2.23.2"
      "sha256-sxWLnz+Rh+KHwOeRqmW3DIOQLmvLv41UCqTkWC0TRFE=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "2.23.2"
      "sha256-x+RsDo6RIQEKZK+Fsezr/Ve+J3qoD4YVVEw7zzLJROU=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "2.23.2"
      "sha256-++Tx6/Ex+gGYJAX7Nxut9oXE0ECJ8Ad9CKeZIMZwOJ0=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "2.23.2"
      "sha256-PNohPrEZAsYtPnf2p/bOS456halWyP8ewQ1jF9dCd20=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "2.23.2"
      "sha256-pYonw9Bt7FHQUw8yrnY2+nceeO42BWawibssxeIs6X8=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "2.23.2"
      "sha256-pH6b8DRar3gPWZAIioTPswn+fRmZfhEP8CLS4EMFl1A=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "2.23.2"
      "sha256-4EkeBQRPO8tmEtVYVQGqTBpa2ZH39YSrS+P/9d2t4CE=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "2.23.2"
      "sha256-lJfvx80/+CvbhXD3QM6x4vACNEjguNK0yHuLxjTGseI=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "2.23.2"
      "sha256-pccbWkeio5leYT9M1F3idCWbqYhZssHVftKZe0TUuSk=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "2.23.2"
      "sha256-/h2kDKfngF3Sbu3++sbGTxiW06A2aDM6VzuSTnG4JsE=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "2.23.2"
      "sha256-MHCnARP17nK9c0EOueaQItZohXhSP6aV1kTc1vZwyWM=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "2.23.2"
      "sha256-WqODS2sC6bV03hlAzFMTgqxU4b2kVJHUCOZfCJTTIRc=";
}
