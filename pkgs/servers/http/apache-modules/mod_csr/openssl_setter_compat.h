/* Licensed to Stichting The Commons Conservancy (TCC) under one or more
 * contributor license agreements.  See the AUTHORS file distributed with
 * this work for additional information regarding copyright ownership.
 * TCC licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// These routines are copies from OpenSSL/1.1.1 its x509/x509_req.c
// and the private header files for that. They are needed as
// starting with OpenSSL 1.1.0 the X509_req structure became
// private; and got some get0 functions to access its internals.
// But no getter's until post 1.1.1 (PR#10563). So this is a
// stopgap for these lacking releases.
//
// Testest against: 
//   openssl-1.0.2t 0x01000214fL (does not need it, privates still accessile)
//   openssl-1.1.0l 0x0101000cfL (needs it)
//   openssl-1.1.1d 0x01010104fL (last version that needs it)
//   openssl-1.1.1-dev		 (should not need it - post PR#10563).
//
/* #if OPENSSL_VERSION_NUMBER >= 0x010100000L &&  OPENSSL_VERSION_NUMBER  <= 0x01010104fL */
#if OPENSSL_VERSION_NUMBER >= 0x010100000L 
#include "openssl/x509.h"

#define HAS_OPENSSL_PR10563_WORK_AROUND

struct X509_req_info_st {
    ASN1_ENCODING enc;          
    ASN1_INTEGER *version;     
    X509_NAME *subject;       
    X509_PUBKEY *pubkey;     
    STACK_OF(X509_ATTRIBUTE) *attributes;
};

typedef _Atomic int CRYPTO_REF_COUNT;

struct X509_req_st {
    X509_REQ_INFO req_info; 
    X509_ALGOR sig_alg;       
    ASN1_BIT_STRING *signature; /* signature */
    CRYPTO_REF_COUNT references;
    CRYPTO_RWLOCK *lock;
# ifndef OPENSSL_NO_SM2
    ASN1_OCTET_STRING *sm2_id;
# endif
};


static void _X509_REQ_set1_signature(X509_REQ *req, X509_ALGOR *palg)
{
    if (req->sig_alg.algorithm)
        ASN1_OBJECT_free(req->sig_alg.algorithm);
    if (req->sig_alg.parameter)
        ASN1_TYPE_free(req->sig_alg.parameter);
    req->sig_alg = *palg;
}
#endif
