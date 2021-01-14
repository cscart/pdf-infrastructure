GW_WWW=/var/www/html/genworker
GW_BASE=docker-compose -f compose/docker-compose.base.yml
GW_PROD=docker-compose -f compose/docker-compose.core.yml -f compose/docker-compose.prod.yml --project-name genworker
GW_LOCAL=docker-compose -f compose/docker-compose.core.yml -f compose/docker-compose.local.yml --project-name genworker
#
include ./compose/.env
export
.PHONY: gw_prod gw_local gw_base gw_prp

gw_base:
	@$(GW_BASE) build

gw_prod:
	@$(GW_PROD) up -d --build

gw_prp:
#PREPARING
	@docker exec -i $$($(GW_PROD) ps -q php) sh -c "cd $(GW_WWW)/app/ && curl -sS https://getcomposer.org/installer | php -- --version=1.7.0 && php composer.phar install"


gw_local:
	@$(GW_LOCAL) up -d

gw_prp_local:
#PREPARING
	@docker exec -i $$($(GW_LOCAL) ps -q php) sh -c "cd $(GW_WWW)/app/ && curl -sS https://getcomposer.org/installer | php -- --version=1.7.0 && php composer.phar install && mkdir -m777 files"

