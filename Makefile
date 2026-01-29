default: list

list:
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:' $(MAKEFILE_LIST) \
		| grep -v '^\.' \
		| awk -F':' '{print $$1}' \
		| grep -v -e 'default' \
		| sort \
		| uniq \
		| awk '{printf "\033[36m%-30s\033[0m\n", $$1}'

install-opencode:
	@if [ -f opencode/opencode.json ]; then \
		echo "Installing opencode config..."; \
		cp opencode/opencode.json ~/.config/opencode/opencode.json; \
		echo "Opencode config installed successfully!"; \
	fi

	@echo "Installing opencode agents..."
	@cp -R opencode/agents/ ~/.config/opencode/agents/
	@echo "Opencode agents installed successfully!"
