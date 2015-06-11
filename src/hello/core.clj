(ns hello.core
  (:require [ring.adapter.jetty :as jetty])
  (:gen-class))

(defn handler [request]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "Hello, Clojure world"})

(defn -main []
  (jetty/run-jetty handler {:port 8080}))
