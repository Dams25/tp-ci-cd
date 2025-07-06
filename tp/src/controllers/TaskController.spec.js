const TaskController = require("./TaskController");

describe("Task Controller - unit test", () => {
  const tasks = [];
  const Task = {
    find: jest.fn(() => tasks),
    findOneAndUpdate: jest.fn(),
  };
  it("all - without search", async () => {
    const req = {
      query: {},
    };
    const res = {
      json: jest.fn(),
    };
    const next = jest.fn();
    const taskController = new TaskController(Task);
    await taskController.all(req, res, next);
    expect(Task.find).toHaveBeenCalledWith(req.query);
    expect(res.json).toHaveBeenCalledWith(tasks);
  });
});
