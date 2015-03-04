package com.pixelus.configserver;

import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.cloud.config.server.EnableConfigServer;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@EnableConfigServer
public class ConfigServer {

    public static void main(final String[] args) {
        new SpringApplicationBuilder(ConfigServer.class)
            .properties("spring.config.name=configserver")
            .run(args);
    }
}