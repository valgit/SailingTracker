packagec:
	@$(JAVA_HOME)/bin/java \
	-Dfile.encoding=UTF-8 \
  	-Dapple.awt.UIElement=true \
	-jar "$(SDK_HOME)/bin/monkeybrains.jar" \
  	-o bin/$(appName).iq \
	-e \
	-w \
	-y $(PRIVATE_KEY) \
	-r \
	-f monkey.jungle
packagei:
	@$(JAVA_HOME)/bin/java \
	-Dfile.encoding=UTF-8 \
  	-Dapple.awt.UIElement=true \
	-jar "$(SDK_HOME)/bin/monkeybrains.jar" \
  	-o International/$(appName)-en.iq \
	-e \
	-w \
	-y $(PRIVATE_KEY) \
	-r \
	-f monkey-en.jungle
packageb:
	@$(JAVA_HOME)/bin/java \
	-Dfile.encoding=UTF-8 \
  	-Dapple.awt.UIElement=true \
	-jar "$(SDK_HOME)/bin/monkeybrains.jar" \
  	-o bin/$(appName)-beta.iq \
	-e \
	-w \
	-y $(PRIVATE_KEY) \
	-r \
	-f monkey-beta.jungle

