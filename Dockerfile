#Build
FROM maven AS build
RUN mkdir /opt/shipping
WORKDIR /opt/shipping
COPY pom.xml /opt/shipping/
# install dependencies
RUN mvn dependency:resolve 
COPY src /opt/shipping/
# to build a Maven project, so that a jar file gets created inside target folder
RUN mvn package 


#Run

FROM openjdk:8-jre-alpine3.9
EXPOSE 8080
RUN mkdir /opt/shipping
WORKDIR /opt/shipping
RUN  addgroup -S roboshop && adduser -S roboshop -G roboshop && \
     chown -R roboshop:roboshop /opt/shipping
COPY -from=build /opt/shipping/target/shipping-*.jar shipping.jar
USER roboshop
CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]