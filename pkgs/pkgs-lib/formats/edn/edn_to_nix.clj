#!/usr/bin/env bb
(ns edn-to-nix
  (:require [clojure.string :as str]
            [clojure.edn :as edn]))

(defn kw->str [kw]
  (str (when-let [n (namespace kw)] (str n "/")) (name kw)))

(comment
  (kw->str :foo)
  (kw->str :foo/bar))

(defn edn-to-nix [edn]
  (cond (map? edn) (if (every? keyword? (keys edn) )
                     ;; simple map with only keywords keys -> nix attrset
                     (str "{" (str/join " " (map (fn [[k v]] (str (pr-str (kw->str k)) " = " (edn-to-nix v) ";")) edn)) "}")
                     ;; complex map with non-keyword keys -> mkMap
                     (str "(mkMap [" (str/join " " (map (fn [[k v]] (str "(mkKV " (edn-to-nix k) " " (edn-to-nix v) ")")) edn)) "])")
                     )
        (vector? edn) (str "[" (str/join " " (map edn-to-nix edn)) "]")
        (set? edn) (str "(mkSet [" (str/join " " (map edn-to-nix edn)) "])")
        (list? edn) (str "(mkList [" (str/join " " (map edn-to-nix edn)) "])")
        (keyword? edn) (str "(mkKeyword \"" (kw->str edn) "\")")
        (symbol? edn) (str "(mkSymbol \"" (str edn) "\")")
        (nil? edn) "null"
        (or (string? edn)
            (int? edn)
            (float? edn)
            (boolean? edn)) (pr-str edn)
        :else (str "(mkRaw " (pr-str edn) ")")))

(defn edn-file-to-nix [path]
  (-> path
      slurp
      edn/read-string
      edn-to-nix
      print))

(defn -main [& args]
  (edn-file-to-nix (first args)))

(when (= *file* (System/getProperty "babashka.file"))
  (apply -main *command-line-args*))
