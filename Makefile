PROJECT = autocluster
PROJECT_DESCRIPTION = Forms RabbitMQ clusters using a variety of backends (AWS EC2, DNS, Consul, Kubernetes, etc)
PROJECT_MOD = autocluster_app
PROJECT_REGISTERED = autocluster_app autocluster_sup autocluster_cleanup

define PROJECT_ENV
[]
endef

DEPS = rabbit_common rabbitmq_aws

TEST_DEPS += rabbit rabbitmq_ct_helpers meck
IGNORE_DEPS += rabbitmq_java_client

DEP_PLUGINS = rabbit_common/mk/rabbitmq-plugin.mk

NO_AUTOPATCH += rabbitmq_aws

dep_rabbitmq_aws = git https://github.com/rabbitmq/rabbitmq-aws.git stable

# FIXME: Use erlang.mk patched for RabbitMQ, while waiting for PRs to be
# reviewed and merged.

ERLANG_MK_REPO = https://github.com/rabbitmq/erlang.mk.git
ERLANG_MK_COMMIT = rabbitmq-tmp
BUILD_DEPS+= rabbit ranch
current_rmq_ref = stable

include rabbitmq-components.mk
include erlang.mk

# --------------------------------------------------------------------
# Testing.
# --------------------------------------------------------------------

plt: PLT_APPS += rabbit rabbit_common ranch mnesia ssl compiler crypto common_test inets sasl ssh test_server snmp xmerl observer runtime_tools tools debugger edoc syntax_tools et os_mon hipe public_key webtool wx asn1 otp_mibs

TEST_CONFIG_FILE=$(CURDIR)/etc/rabbit-test

WITH_BROKER_TEST_COMMANDS := autocluster_all_tests:run()
