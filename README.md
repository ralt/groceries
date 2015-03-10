# groceries

Because I'm lazy and likes my grocery lists easy.

The application will be an SPA, with a list of grocery items.

Adding an item will be easy (auto-completion), "checking" an item
(i.e. picking it up at the mall) will be done with a simple touch, and
removing it with another touch.

Backend-side, it means only one route returns HTML. Eventually 2, if I
add login. Other routes will just return JSON.

Fun thing: every SQL request will be done using stored procedures.

Screenshot:

![screenshot](http://i.imgur.com/W4ZrKNL.png)

## List of environment variables

- `ADDRESS`: IP address (or hostname) on which the web server listens
- `PORT`: IP port on which the web server listens
- `DBNAME`: database name
- `DBUSER`: database user
- `DBPASS`: database password
- `DBHOST`: database host
- `DBPORT`: database port (defaults to 5432)
- `DOCUMENT_ROOT`: public folder where css/js files reside. Defaults to
  `(merge-pathnames #p"static/" (asdf:system-source-directory :groceries))`.
