const app = require("./app");
const port = process.env.PORT || 4000;

app.listen(port, (err) => {
  if (err) {
    console.log(`Error: ${err}`);
  }
  console.log(
    `${process.env.START_MESSAGE}! Server is running on port ${port}`
  );
});
