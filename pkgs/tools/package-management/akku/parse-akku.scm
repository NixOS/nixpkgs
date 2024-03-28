(import (srfi 1)
        (srfi 28))


(define-syntax anif
  (syntax-rules (:=)
    ((_ (bool := sym) x y)
     (let ((sym bool))
       (if sym x y)))
    ((_ b x)
     (anif b x #f))))

(define ref assoc-ref)

(define (sref alist key)
  ;; Used to reach b in pairs like (a . (b))
  (anif ((ref alist key) := t)
    (car t)
    #f))

(define (printf str . args)
  (display (apply format (cons str args))))

(define (->string x)
  (cond
    ((symbol? x) (symbol->string x))
    ((number? x) (number->string x))
    (else x)))

(define (module-name->string module)
  (if (pair? module)
    (string-join (map ->string module) "-")
    module))

(define (normalize-deps deps)
  (map (compose module-name->string car) deps))

(define (parse-license license)
  (with-input-from-string license
    (lambda ()
      (let ((res (read)))
        (if (pair? res)
          (map (compose string-downcase ->string)
               (filter (lambda (sym) (not (eq? sym 'AND))) res))
          (string-downcase (->string res)))))))

(define (parse-version-info alist)
  (let* ((lock (ref alist 'lock))
         (url (sref (ref lock 'location) 'url))
         (sha256 (sref (ref lock 'content) 'sha256))
         (depends (normalize-deps (ref alist 'depends)))
         (dev-depends
           (anif ((ref alist 'depends/dev) := t)
             (normalize-deps t)
             (list)))
         (license (parse-license (sref alist 'license))))
    (append `((license ,license)
              (url ,url)
              (sha256 ,sha256)
              (depends ,depends)
              (dev-depends ,dev-depends))
            alist)))

(define (format-list lst)
  (define (surround s)
    (format "~s" s))
  (string-append
    "["
    (apply string-join (list (map surround lst) ", "))
    "]"))

(define (write-package sexp)
  (let* ((latest (parse-version-info (last (ref sexp 'versions))))
         (license (sref latest 'license))
         (url (sref latest 'url)))
    (printf "[~a]\n" (module-name->string (sref sexp 'name)))
    (printf "dependencies = ~a\n" (format-list (sref latest 'depends)))
    (printf "dev-dependencies = ~a\n" (format-list (sref latest 'dev-depends)))
    (if (pair? license)
      (printf "license = ~a\n" (format-list license))
      (printf "license = ~s\n" license))
    (printf "url = ~s\n" url)
    (printf "sha256 = ~s\n" (sref latest 'sha256))
    (printf
      "source = ~s\n"
      (cond
        ((eq? 0 (string-contains url "https://archive.akkuscm.org/")) "akku")
        ((eq? 0 (string-contains url "http://snow-fort.org/")) "snow-fort")
        (else "UNKNOWN")))
    (anif ((sref latest 'synopsis) := t)
      (printf "synopsis = ~s\n" t))
    (printf "version = ~s\n" (sref latest 'version))
    (anif ((sref latest 'hompeage) := t)
      (printf "homepage = ~s\n" t))
    (newline)))

(define (main-deps)
  (let ((res (read)))
    (if (eof-object? res)
      (exit 0))
    (write-package (cdr res))
    (main-deps)))


; (define (merge a b)
;   (define (helper acc a b))
;   (map (lambda (a1 b1)
;          (helper))))
; (define (merge-meta acc res)
;   (let* ((flattened
;            (map (lambda (l)
;                   (case (car l)
;                     ((define) (cdr l))
;                      (else l))) res))
;          )
;     )
;   )
; (define (main-merge acc)
;   (read)
;   (let ((res (read)))
;     (if (eof-object? res)
;       (exit 0))
;     (main-merge (merge acc (cdr res)))
;     (main-merge))
;   )

(case (string->symbol (cadr (command-line)))
  ((deps)
   (read)
   (main-deps))
  ; ((merge)
  ;  (write (cons 'library (main-merge acc))))
  (else
    (display "mode not found")
    (newline)))

