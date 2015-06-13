(defproject hello "0.1.0-SNAPSHOT"
  :description "Clojure in a container."
  :url "https://github.com/mfellner/build-container"
  :dependencies [[org.clojure/clojure "1.7.0-RC1"]
                 [ring/ring-core "1.4.0-RC1"]
                 [ring/ring-devel "1.4.0-RC1"]
                 [ring/ring-jetty-adapter "1.4.0-RC1"]]
  :plugins [[lein-ring  "0.9.5"]]
  :main ^:skip-aot hello.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}}
  :uberjar-name "app.uber.jar"
  :ring {:handler hello.core/handler})
