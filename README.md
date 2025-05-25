## Database Assignment

This repo contains the assignment for the "gestion de datos" subject in UTN frba.

### How to Make a Submission

1. Create the Submission Folder  
   In the [`submissions`](./submissions/) directory, create a new folder named after the submission number (e.g., `01`, `02`, etc.). This folder should contain all the files for that specific submission.

2. **Generate the Submission Package**:

```bash
 make create_submission SUBMISSION=<FOLDER_NAME>
```

This command will:

-   Create a `.zip` file with the contents of the submission folder.
-   Automatically include the required `Readme.txt` file.
-   Display the email template with all the details you need to send.
-   Create a Git tag for the submission.

2. **Push the Submission Package**: If everything looks correct, push the submission tag to GitHub by running:

```bash
make push_submission
```

Then:

-   Go to the **tag page on GitHub**.
-   Click **“Create a Release”** (or select the tag).
-   Attach the generated `.zip` file to the release.
