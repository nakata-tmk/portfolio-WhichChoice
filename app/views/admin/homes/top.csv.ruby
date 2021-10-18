require 'csv'

CSV.generate(encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
  column_names = %w(投稿日 投稿者名 ジャンル名 質問事項1  質問事項2 本文 回答数1 回答数2 コメント数 いいね数)
  csv << column_names
  @questions = Question.all
  @questions.each do |question|
    column_values = [
      question.created_at.strftime('%Y/%m/%d'),
      question.user.name,
      question.genre.name,
      question.object1,
      question.object2,
      question.body,
      Answer.where(question_id: question.id, answer: 0).count,
      Answer.where(question_id: question.id, answer: 1).count,
      question.comments.count,
      question.favorites.count
    ]
    csv << column_values
  end
end