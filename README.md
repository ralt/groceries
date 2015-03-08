# groceries

Because I'm lazy and likes my grocery lists easy.

The application will be an SPA, with a list of grocery items.

Adding an item will be easy (auto-completion), "checking" an item
(i.e. picking it up at the mall) will be done with a simple touch, and
removing it with another touch.

Backend-side, it means only one route returns HTML. Eventually 2, if I
add login. Other routes will just return JSON.

Fun thing: every SQL request will be done using stored procedures.


### Notes

- select items() should be select items(list_id) and *not* return the
  items already in the list

- clean up the js by splitting up stuff in their own modules

- Finished the event listener to add stuff in a list... but make the
  list in the html first
