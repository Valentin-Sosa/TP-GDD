.PHONY: push_delivery create_delivery zip_delivery

create_delivery: zip_delivery
	@echo "Delivery for $(DELIVERY) has been created, now send the following email:":
	@git tag -a v$(DELIVERY).0.0 -m "TP1C2025 K3014 MAUV 4 - Entrega $(DELIVERY)"
	@cat assignment/mail.txt

push_delivery:
	@echo "Pushing delivery tag to github..."
	@git push --tags origin
	@echo "Delivery pushed, you can attach the assignment .zip to it."

zip_delivery:
	@rm ./assignment/$(DELIVER)/mauv123.zip
	@zip -j -r ./assignment/$(DELIVER)/mauv123.zip assignment/$(DELIVER)/* assignment/Readme.txt


