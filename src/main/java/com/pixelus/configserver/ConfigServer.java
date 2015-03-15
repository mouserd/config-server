package com.pixelus.configserver;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.cloud.config.server.EnableConfigServer;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@EnableConfigServer
//@ImportResource({"classpath:aws-config.xml"})
//@EnableContextInstanceData
public class ConfigServer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(final SpringApplicationBuilder applicationBuilder) {
        return applicationBuilder.sources(ConfigServer.class);
    }

    public static void main(final String[] args) {
        new SpringApplicationBuilder(ConfigServer.class)
            .properties("spring.config.name=configserver")
            .run(args);
    }
}