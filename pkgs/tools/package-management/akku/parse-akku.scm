(import (srfi 1)
        (srfi 28)
        (ice-9 pretty-print))


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
  (let ((res (with-input-from-string license read)))
    (if (pair? res)
      (map (compose string-downcase ->string)
           (filter (lambda (sym) (not (eq? sym 'AND))) res))
      (string-downcase (->string res)))))

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
        ;; because #f could be returned
        ((eqv? 0 (string-contains url "https://archive.akkuscm.org/")) "akku")
        ((eqv? 0 (string-contains url "http://snow-fort.org/")) "snow-fort")
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


(define (read-meta meta)
  (with-input-from-file meta read))

(define (find-definition meta sym)
  ;; cddr for
  ;; (define sym definition ...)
  ;;             ^
  (cddr (find (lambda (a)
                (and (pair? a)
                     (eq? (car a) 'define)
                     (eq? (cadr a) sym)))
              meta)))

(define (installed-libraries meta)
  ;; cadar for
  ;; ((quote ((chibi diff) (chibi diff-test))))
  ;;         ^
  (cadar (find-definition meta 'installed-libraries)))

(define (installed-assets meta)
  (cadar (find-definition meta 'installed-assets)))

(define (main-merge name version self-path . rest-paths)
  (let* ((self (read-meta self-path))
         (metas (map read-meta (cons self-path rest-paths)))
         (joined-libraries (append-map installed-libraries metas))
         (joined-assets (append-map installed-assets metas)))
    (set-car! (find-definition self 'installed-libraries)
              `',(delete-duplicates joined-libraries))
    (set-car! (find-definition self 'installed-assets)
              `',(delete-duplicates joined-assets))
    (set-car! (find-definition self 'main-package-name)
              `',name)
    (set-car! (find-definition self 'main-package-version)
              `',version)
    self))

(case (string->symbol (cadr (command-line)))
  ((deps)
   (read)
   (main-deps))
  ((merge)
   (pretty-print (apply main-merge (cddr (command-line)))))
  (else
    (display "mode not found")
    (newline)))

