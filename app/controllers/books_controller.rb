class BooksController < ApplicationController
	
	before_action :find_book, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, only: [:edit, :new]

	def index
        if params[:category].blank?
		   @books=Book.all.order("created_at DESC")
        else
            @category_id=Category.find_by(name: params[:category]).id
            @books= Book.where(:category_id => @category_id).order("created_at DESC")
        end
	end

     def new 
       	@book=current_user.books.build
        @categories= Category.all.map{ |c| [c.name,c.id] }
     end

     def show
        if @book.reviews.blank?
            @average_rating =0
        else
            @average_rating = @book.reviews.average(:rating).round(2)
        end
     end
     
    def edit
         @categories= Category.all.map{ |c| [c.name,c.id] }
    end

    def update
         @book.category_id= params[:category_id]
    	
        if @book.update(books_params)
    		redirect_to book_path(@book)
    	else
    		render 'edit'
    	end
    
    end

    def destroy
        @book.destroy
    	redirect_to root_path
    end

     def create
     	@book=current_user.books.build(books_params)
        @book.category_id= params[:category_id]
     	if @book.save  #whether book is saved or not
     		redirect_to root_path  #move to index page
     	else
     		render 'new'   #else render new form
     	end
  	 end

private
	
	def books_params
		params.require(:book).permit(:title, :description, :author, :category_id, :book_img )
	end
    
    def find_book
    	@book=Book.find(params[:id])
    end

end
