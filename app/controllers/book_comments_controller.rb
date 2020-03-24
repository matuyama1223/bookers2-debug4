class BookCommentsController < ApplicationController
			# 投稿
	def create
		book = Book.find(params[:book_id])
		comment = current_user.book_comments.new(book_commment_params)
		comment.book_id = book.id
		comment.save
		redirect_to book_path(book)

	end

	# けす
	def destroy
		book_comment = BookComment.find(params[:id])
		book_comment.destroy
		redirect_to request.referer
		# request.referer	消えて前に戻る

	end
	def book_commment_params
		params.require(:book_comment).permit(:comment)
	end

end
