from sqlalchemy.ext.hybrid import hybrid_property
from src import db, BaseMixin, ReprMixin


class Campaign(db.Model, BaseMixin, ReprMixin):

    name = db.Column(db.String(80), nullable=False)
    code = db.Column(db.String(80), unique=True)
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)


class Task(db.Model, BaseMixin):

    campaign_id = db.Column(db.Integer, db.ForeignKey('campaign.id'), nullable=False)
    type = db.Column(db.Integer, db.ForeignKey('task_type.id'), nullable=False)
    choice_group_id = db.Column(db.Integer, db.ForeignKey('choice_group.id'), nullable=False)

    choice_group = db.relationship('ChoiceGroup', uselist=False, lazy='dynamic')

    @hybrid_property
    def choices(self):
        return self.choice_group.choices


class Question(db.Model, BaseMixin):

    question = db.Column(db.Text(), nullable=False)
    question_type = db.Column(db.Integer, db.ForeignKey('question_type.id'), nullable=False)
    task_id = db.Column(db.Integer, db.ForeignKey('task.id'), nullable=False)

    task = db.relationship('Task', foreign_key=[task_id], backref='questions')

    @hybrid_property
    def choices(self):
        return self.task.choices


class TaskType(db.Model, BaseMixin, ReprMixin):
    name = db.Column(db.String(80), nullable=False)
    parent_id = db.Column(db.Integer, db.ForeignKey('task_type.id'), nullable=True)


class QuestionType(db.Model, BaseMixin, ReprMixin):
    name = db.Column(db.String(80), nullable=False)
    parent_id = db.Column(db.Integer, db.ForeignKey('question_type.id'), nullable=True)


class TaskToUser(db.Model, BaseMixin):
    task_id = db.Column(db.Integer, db.ForeignKey('task.id'), nullable=False)
    task_status_id = db.Column(db.Integer, db.ForeignKey('task_status.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)

    time_left = db.Column(db.Time)
    start_time = db.Column(db.DateTime)
    end_time = db.Column(db.DateTime)

    is_accepted = db.Column(db.Boolean(False))

    task = db.relationship('Task', uselist=False, lazy='dynamic', cascade="all, delete-orphan")

    @hybrid_property
    def all_questions(self):
        return self.task.questions.all()


class TaskStatus(db.Model, BaseMixin, ReprMixin):
    name = db.Column(db.String(128), nullable=False)
    code = db.Column(db.Integer, nullable=False)


class ChoiceGroup(db.Model, BaseMixin, ReprMixin):

    name = db.Column(db.String(80), nullable=False)
    choices = db.relationship('ChoiceGroupToChoice', back_populates='choice_group')


class ChoiceGroupToChoice(db.Model, BaseMixin):

    choice_group_id = db.Column(db.Integer, db.ForeignKey('choice_group.id'), nullable=False)
    choice_id = db.Column(db.Integer, db.ForeignKey('task_choice.id'), nullable=False)

    choice_group = db.relationship('ChoiceGroup', back_populates='choices')
    choice = db.relationship('TaskChoice', back_populates='choice_groups')


class TaskChoice(db.Model, BaseMixin):

    choice = db.Column(db.String(120), nullable=False)
    choice_group = db.relationship('ChoiceGroupToChoice', back_populates='choice')


class TaskUserAnswer(db.Model, BaseMixin):

    task_to_user_id = db.Column(db.Integer, db.ForeignKey('task_to_user.id'), nullable=False)
    question_id = db.Column(db.Integer, db.ForeignKey('question.id'), nullable=False)
    choice_id = db.Column(db.Integer, db.ForeignKey('task_choice.id'), nullable=False)
    is_accepted = db.Column(db.Boolean(False))