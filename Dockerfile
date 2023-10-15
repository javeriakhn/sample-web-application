FROM tomcat
WORKDIR /usr/local/tomcat/webapps
COPY target/WebApp.war ./ROOT.war
ENTRYPOINT ["catalina.sh", "run"]
