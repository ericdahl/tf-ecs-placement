#!/bin/bash
echo ECS_CLUSTER='tf-ecs-placement' >> /etc/ecs/ecs.config
echo ECS_INSTANCE_ATTRIBUTES='{"Special": "true"}' >> /etc/ecs/ecs.config
