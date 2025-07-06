module.exports = class TaskController {
  #Task;

  constructor(Task) {
    this.#Task = Task;
  }

  async all(req, res, next) {
    const tasks = await this.#Task.find(req.query);

    return res.json(tasks);
  }

  async update(req, res, next) {
    const task = await this.#Task.findOneAndUpdate(
      { _id: req.params.id },
      req.body,
      {
        new: true,
      }
    );

    if (!task) {
      return res.sendStatus(404);
    }

    return res.json(task);
  }
};
