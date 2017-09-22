module MetaCommit::Factories
  # Factory that builds ContextualAstNode from ast nodes
  class ContextualAstNodeFactory

    # @param [Parser::AST::Node] source_ast
    # @param [Integer] line_number
    # @return [MetaCommit::Models::ContextualAstNode]
    def create_ast_path(source_ast, line_number)
      visited_nodes = []
      ast_path = MetaCommit::Models::ContextualAstNode.new
      ast_path.target_node = collect_path_to_ast_at_line(source_ast, line_number, visited_nodes)
      ast_path.context_nodes = visited_nodes
      ast_path
    end

    protected
    def get_ast_at_line(ast, lineno)
      return nil unless ast_covers_line(ast, lineno)
      closest_ast = ast
      ast.children.each do |child|
        found_ast = get_ast_at_line(child, lineno)
        closest_ast = found_ast unless found_ast.nil?
      end
      closest_ast
    end

    protected
    def collect_path_to_ast_at_line(ast, lineno, accumulator)
      return nil unless ast_covers_line(ast, lineno)
      closest_ast = ast
      accumulator.push(closest_ast)
      ast.children.each do |child|
        found_ast = collect_path_to_ast_at_line(child, lineno, accumulator)
        closest_ast = found_ast unless found_ast.nil?
      end
      closest_ast
    end

    protected
    def ast_covers_line(ast, line)
      return false unless (ast.respond_to?(:loc) && ast.loc.respond_to?(:expression) && !ast.loc.expression.nil?)
      (ast.loc.first_line <= line) && (ast.loc.last_line >= line)
    end
  end
end