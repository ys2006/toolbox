package com.myorg;

import software.amazon.awscdk.core.App;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import org.hamcrest.CoreMatchers;
import org.junit.Test;

import java.io.IOException;

import static org.junit.Assert.assertThat;

public class MyEcsConstructTest {
    private final static ObjectMapper JSON =
        new ObjectMapper().configure(SerializationFeature.INDENT_OUTPUT, true);

    @Test
    public void testStack() throws IOException {
        App app = new App();
        MyEcsConstructStack stack = new MyEcsConstructStack(app, "test");

        // synthesize the stack to a CloudFormation template and compare against
        // a checked-in JSON file.
        JsonNode actual = JSON.valueToTree(app.synth().getStackArtifact(stack.getArtifactId()).getTemplate());
		assertThat(actual.toString(), CoreMatchers.both(CoreMatchers.containsString("AWS::ECS::Cluster")).and(CoreMatchers.containsString("AWS::ElasticLoadBalancingV2::LoadBalancer")));
    }
}
