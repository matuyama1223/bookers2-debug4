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
		book = Book.find(params[:book_id])
		comment = current_user.book_comments(paramas)
		comment.destroy
		redirect_to book_path(book)
		
	end
	def book_commment_params
		params.require(:book_comment).permit(:comment)
	end

end
