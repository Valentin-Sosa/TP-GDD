.PHONY: push_submission create_delivery zip_submission

create_submission: zip_submission
	@echo "Submission for $(SUBMISSION) has been created, now send the following email:":
	@git tag -a v$(SUBMISSION).0.0 -m "TP1C2025 K3014 MAUV 4 - Entrega $(SUBMISSION)"
	@cat submissions/mail.txt

push_submission:
	@echo "Pushing submission tag to github..."
	@git push --tags origin
	@echo "submission pushed, you can attach the assignment .zip to it."

zip_submission:
	@rm ./submissions/$(SUBMISSION)/mauv123.zip
	@zip -j -r ./submissions/$(SUBMISSION)/mauv123.zip submissions/$(SUBMISSION)/* submissions/Readme.txt
