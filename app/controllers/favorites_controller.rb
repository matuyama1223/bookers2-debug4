class FavoritesController < ApplicationController
	# 投稿
	def create
		 book = Book.find(params[:book_id])
            favorite = current_user.favorites.new(book_id: book.id)
            favorite.save
            redirect_to books_path
	end
	# 削除
	def destroy 
		    book = Book.find(params[:book_id])
            favorite = current_user.favorites.find_by(book_id: book.id)
            favorite.destroy
            redirect_to books_path



	end
end